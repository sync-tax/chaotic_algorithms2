"_-[ chaotic algorithms2 ]-_'
================================================.
     .-.   .-.     .--.                         |
    | OO| | OO|   / _.-' .-.   .-.  .-.   .''.  |"
#----------------------------------------------------------------------
# PRESETS
use_bpm 146
use_debug false

live_loop :metro do
  sleep 1
end

define :pattern do |p|
  return p.ring.tick == "x"
end
#----------------------------------------------------------------------
#SAMPLES
kick = "/insert/sample/path/^^.wav" # I used another sample for that, but u can stick to sonic pi samples

#----------------------------------------------------------------------
#PATTERNS
kick_pattern = ("xxxxxxxxxxxxx_x_xxxxxxxxxxxxxxx_")

kick_pattern2 = ("x__xx__xx__xx_x_")

kick_pattern3 = ("xxxx")

snare_pattern = ("x_x_x_x_x_x_x_")

piep_pattern = ("xx___x___x___x__")

wroom_pattern = ("_x_x_x_x_x_x_x_x_x_x_x_x_x_x")

#----------------------------------------------------------------------
#MIXER
master = 1

base = 1.0

kick_amp = 1.0 * base
bass_amp = 0.4 * base

hihat_amp = 0.0 * base
snare_amp = 0.0 * base
wroom_amp_ramp = (ramp * range(0.0001, 0.00, 0.0025))
piep_amp = 0 * base

drone1_amp = 0.0
drone2_amp = 0.15

synth_amp_ramp = (ramp * range(0.000002, 0.15, 0.0015))

syn_time = 1
#----------------------------------------------------------------------
#LIVE LOOPS
live_loop :kick do
  sleep 1
  if pattern(kick_pattern2)
    with_fx :eq, low_shelf: -0.05, low: -0.05 do
      sample :bd_tek,
        amp: kick_amp,
        beat_stretch: 1.1,
        cutoff: 90 #60, 80
    end
  end
end

live_loop :bass, sync: :kick do
  sleep 0.5
  with_synth :fm do
    play :d2,
      amp: bass_amp * master,
      attack: 0.15,
      decay: 0.125,
      sustain: 0.1,
      release: 0.1,
      depth: 0.5,
      pitch: 4,
      cutoff: 100
  end
  sleep 0.5
end

live_loop :hihat , sync: :metro do
  with_fx :gverb, dry: 1, release: 0.25 do
    sample :hat_yosh, amp: hihat_amp * master, rate: 12, cutoff: 80
    sleep 0.5
    sample :hat_yosh, amp: hihat_amp * master, rate: 2, cutoff: 100
    sleep 0.5
    sample :hat_yosh, amp: hihat_amp * master, rate: 12, cutoff: 90
    sleep 0.5
    sample :hat_yosh, amp: hihat_amp * master, rate: 2, cutoff: 100
    sleep 0.5
  end
end

live_loop :snare do
  if pattern(snare_pattern)
    with_fx :reverb, mix: 0.5, room: 0.35 do
      sample :sn_zome, #sn_dub
        amp: snare_amp * master,
        beat_stretch: 0.15, #0.15 | 0.25
        cutoff: 80
    end
  end
  sleep 1
end

live_loop :wroom, sync: :metro do
  stop
  if pattern(wroom_pattern)
    with_fx :reverb do
      with_fx :echo, phase: 0.5 do
        sample :elec_blup,
          amp: wroom_amp_ramp.look * master,
          release: 0.25,
          rate:  3,
          cutoff: 90
      end
    end
  end
  sleep 1
end

live_loop :piep do
  if pattern(piep_pattern)
    with_fx :reverb, mix: 0.5 do
      sample :elec_bell,
        amp: piep_amp * master,
        beat_stretch: 1,
        rate: 12,
        cutoff: 80
    end
  end
  sleep 1
end

live_loop :atmo do
  atmo_co = range(70, 75, 2.5).mirror
  if drone1_amp > 0
    with_fx :gverb, damp: 1, mix: 0.75, dry: 0.5 do
      with_fx :reverb, mix: 0.6, room: 0.75 do
        with_fx :slicer, phase: 0.5 do
          sample :arovane_beat_b,
            amp: drone1_amp * master,
            pan: (ring, 1, -1, -1, 1 ).tick,
            release: 0.25,
            attack: 0.05,
            rate: 1,
            beat_stretch: 12,
            pitch: 12,
            cutoff: atmo_co.look
          sleep 8
        end
      end
    end
  else
    with_fx :reverb, mix: 0.5, room: 0.2 do
      with_fx :slicer, phase: 0.5 do
        sample :arovane_beat_b,
          amp: drone2_amp * master,
          release: 0.1,
          attack: 0.5,
          rate: 1, # 0.75, 1
          cutoff: rrand(80, 110)
        sleep 8
      end
    end
  end
end

live_loop :synth , sync: :metro do
  #stop
  synth_co = range(60, 100).mirror
  with_fx :ping_pong, phase: 1 do
    use_random_seed ring(200, 300, 200, 600).tick #200, 300, 200, 600 | 2200, 2300, 2200, 2600 | 20, 30, 20, 80
    syn_time.times do
      with_synth :bass_foundation do
        n1 = (ring :d1, :e2, :e1, :c1, :b2, :g1).shuffle
        n2 = (ring :b1, :c2, :d1).choose
        play n2,
          amp: synth_amp_ramp.look * master,
          release: rrand(0.25, 0.4), #rrand(1.25, 1.4)
          res: 0.8,
          wave: 1,
          pitch: 12,
          cutoff: rrand(60, 100)
        sleep 0.5
      end # 0.5 2
    end
  end
end
#----------------------------------------------------------------------