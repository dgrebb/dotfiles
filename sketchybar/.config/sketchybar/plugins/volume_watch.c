// Pushes output volume into sketchybar.
// SketchyBar's built-in volume_change listener stops delivering events on
// this machine (it stays latched at 0), so the slider never tracks the keys.
#include <CoreAudio/CoreAudio.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

static int g_pipe[2];
static AudioObjectID g_device = kAudioObjectUnknown;

static AudioObjectPropertyAddress addr(AudioObjectPropertySelector sel,
                                        AudioObjectPropertyScope scope,
                                        AudioObjectPropertyElement el) {
  AudioObjectPropertyAddress a = {sel, scope, el};
  return a;
}

static AudioObjectID default_output(void) {
  AudioObjectID id = kAudioObjectUnknown;
  UInt32 size = sizeof(id);
  AudioObjectPropertyAddress a = addr(kAudioHardwarePropertyDefaultOutputDevice,
                                      kAudioObjectPropertyScopeGlobal,
                                      kAudioObjectPropertyElementMain);
  AudioObjectGetPropertyData(kAudioObjectSystemObject, &a, 0, NULL, &size, &id);
  return id;
}

static int read_percent(AudioObjectID id) {
  if (id == kAudioObjectUnknown) return -1;

  UInt32 muted = 0;
  UInt32 size = sizeof(muted);
  AudioObjectPropertyAddress mute = addr(kAudioDevicePropertyMute,
                                         kAudioObjectPropertyScopeOutput,
                                         kAudioObjectPropertyElementMain);
  if (AudioObjectGetPropertyData(id, &mute, 0, NULL, &size, &muted) == 0 && muted)
    return 0;

  Float32 vol = 0.f;
  size = sizeof(vol);
  AudioObjectPropertyAddress level = addr(kAudioDevicePropertyVolumeScalar,
                                          kAudioObjectPropertyScopeOutput,
                                          kAudioObjectPropertyElementMain);
  if (AudioObjectGetPropertyData(id, &level, 0, NULL, &size, &vol) != 0)
    return -1;

  int pct = (int)(vol * 100.f + 0.5f);
  if (pct < 0) pct = 0;
  if (pct > 100) pct = 100;
  return pct;
}

static void publish(int pct) {
  if (pct < 0) return;
  if (write(g_pipe[1], &pct, sizeof pct) != (ssize_t)sizeof pct) {
    /* reader is gone */
  }
}

static void bind_device(AudioObjectID id);

static OSStatus on_level(AudioObjectID id, UInt32 count,
                         const AudioObjectPropertyAddress *addresses,
                         void *context) {
  (void)id;
  (void)count;
  (void)addresses;
  (void)context;
  publish(read_percent(g_device));
  return 0;
}

static OSStatus on_device(AudioObjectID id, UInt32 count,
                          const AudioObjectPropertyAddress *addresses,
                          void *context) {
  (void)id;
  (void)count;
  (void)addresses;
  (void)context;
  bind_device(default_output());
  publish(read_percent(g_device));
  return 0;
}

static void unbind(AudioObjectID id) {
  if (id == kAudioObjectUnknown) return;
  AudioObjectPropertyAddress level = addr(kAudioDevicePropertyVolumeScalar,
                                          kAudioObjectPropertyScopeOutput,
                                          kAudioObjectPropertyElementMain);
  AudioObjectPropertyAddress mute = addr(kAudioDevicePropertyMute,
                                         kAudioObjectPropertyScopeOutput,
                                         kAudioObjectPropertyElementMain);
  AudioObjectRemovePropertyListener(id, &level, on_level, NULL);
  AudioObjectRemovePropertyListener(id, &mute, on_level, NULL);
}

static void bind_device(AudioObjectID id) {
  if (id == g_device) return;
  unbind(g_device);
  g_device = id;
  if (id == kAudioObjectUnknown) return;

  AudioObjectPropertyAddress level = addr(kAudioDevicePropertyVolumeScalar,
                                          kAudioObjectPropertyScopeOutput,
                                          kAudioObjectPropertyElementMain);
  AudioObjectPropertyAddress mute = addr(kAudioDevicePropertyMute,
                                         kAudioObjectPropertyScopeOutput,
                                         kAudioObjectPropertyElementMain);
  AudioObjectAddPropertyListener(id, &level, on_level, NULL);
  AudioObjectAddPropertyListener(id, &mute, on_level, NULL);
}

int main(void) {
  if (pipe(g_pipe) != 0) return 1;

  AudioObjectPropertyAddress devices = addr(kAudioHardwarePropertyDefaultOutputDevice,
                                            kAudioObjectPropertyScopeGlobal,
                                            kAudioObjectPropertyElementMain);
  AudioObjectAddPropertyListener(kAudioObjectSystemObject, &devices, on_device, NULL);
  bind_device(default_output());
  publish(read_percent(g_device));

  int quiet = 1;
  int last = -1;
  int pct = 0;
  while (read(g_pipe[0], &pct, sizeof pct) == (ssize_t)sizeof pct) {
    int flags = fcntl(g_pipe[0], F_GETFL, 0);
    fcntl(g_pipe[0], F_SETFL, flags | O_NONBLOCK);
    int extra = 0;
    while (read(g_pipe[0], &extra, sizeof extra) == (ssize_t)sizeof extra)
      pct = extra;
    fcntl(g_pipe[0], F_SETFL, flags);

    if (pct == last) continue;
    last = pct;

    char cmd[192];
    snprintf(cmd, sizeof cmd,
             "sketchybar --trigger volume_sync INFO=%d%s >/dev/null 2>&1",
             pct, quiet ? " VOLUME_QUIET=1" : "");
    quiet = 0;
    system(cmd);
  }
  return 0;
}
