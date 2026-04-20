-- Sound
local prp_volume = user_prop_add_percentage("Sound effect volume", 0.0, 1.0, 1.0, "Volume of the sound effects")
local prp_play_tact = user_prop_add_boolean("Sound effects buttons", false, "Play sound effects for buttons or not")
local prp_play_enco = user_prop_add_boolean("Sound effects encoders", false, "Play sound effects for encoders or not")

-- Tact switch
local snd_click_press   = sound_add("sound/button_press.wav")
local snd_click_release = sound_add("sound/button_release.wav")
sound_volume(snd_click_press, user_prop_get(prp_volume) )
sound_volume(snd_click_release, user_prop_get(prp_volume) )

function tact_switch(action)

    if user_prop_get(prp_play_tact) then
        if action == "PRESS" then
            sound_play(snd_click_press)
        else
            sound_play(snd_click_release)
        end
    end

end

-- Encoder button
local snd_enc_press   = sound_add("sound/encoder_pressed.wav")
local snd_enc_release = sound_add("sound/encoder_released.wav")
sound_volume(snd_enc_press, user_prop_get(prp_volume) )
sound_volume(snd_enc_release, user_prop_get(prp_volume) )

function encoder_button(action)

    if user_prop_get(prp_play_tact) then
        if action == "PRESS" then
            sound_play(snd_enc_press)
        else
            sound_play(snd_enc_release)
        end
    end

end

-- Encoder dial
local snd_enc_rotate_big   = sound_add("sound/encoder_big_rotate.wav")
local snd_enc_rotate_small = sound_add("sound/encoder_big_rotate.wav")
sound_volume(snd_enc_rotate_big, user_prop_get(prp_volume) )
sound_volume(snd_enc_rotate_small, user_prop_get(prp_volume) )

function encoder_rotate(type)

    if user_prop_get(prp_play_enco) then
        if type == "BIG" then
            sound_play(snd_enc_rotate_big)
        else
            sound_play(snd_enc_rotate_small)
        end
    end

end