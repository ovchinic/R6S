-- /////////// Recoil Control Settings - Cycling Profile Version /////////

-- //////////////////////////////////////// RECOIL PROFILES ////////////////////////////////////////////////

Profiles = {
    {
        Recoil = 3,
        Delay = 8,
        RapidFireDelay = 80,
        RapidFireRecoil = 16,
        PressDuration = 9
    },
    {
        Recoil = 6,
        Delay = 8,
        RapidFireDelay = 110,
        RapidFireRecoil = 9,
        PressDuration = 9
    },
    {
        Recoil = 10,
        Delay = 9,
        RapidFireDelay = 130,
        RapidFireRecoil = 12,
        PressDuration = 10
    }
}

HorizontalRecoilModifier = -0.2

-- //////////////////////////////////////// CONTROL TOGGLES ////////////////////////////////////////////////
LockKey = "numlock"
RapidFireButton = 11

-- //////////////////////////////////////// INTERNAL VARS //////////////////////////////////////////////////
RapidFireSleepMin = 0
RapidFireSleepMax = 0
MouseMove = 0
Countx = 0
LC = 1
RC = 3
CurrentProfile = 1

-- //////////////////////////////////////// PROFILE HANDLER ////////////////////////////////////////////////
function LoadProfile(index)
    if index > #Profiles then
        index = 1
        CurrentProfile = 1
    end

    local profile = Profiles[index]
    ActiveRecoil = profile.Recoil
    ActiveDelay = profile.Delay
    ActiveRapidFireDelay = profile.RapidFireDelay
    MouseMove = profile.RapidFireRecoil
    PressSpeedMin = profile.PressDuration - 1
    PressSpeedMax = profile.PressDuration + 1
    SleepNoRecoilMin = profile.Delay - 1
    SleepNoRecoilMax = profile.Delay + 1

    if profile.RapidFireDelay > 10 then
        RapidFireSleepMin = profile.RapidFireDelay - 5
        RapidFireSleepMax = profile.RapidFireDelay + 5
    else
        RapidFireSleepMin = 5
        RapidFireSleepMax = profile.RapidFireDelay + 5
    end
end

LoadProfile(CurrentProfile)

function Resetter()
    Countx = 0
end

function RapidFire()
    repeat
        PressMouseButton(LC)
        Sleep(math.random(PressSpeedMin, PressSpeedMax))
        ReleaseMouseButton(LC)
        Sleep(math.random(2, 4))
        MoveMouseRelative(0, MouseMove)
        Sleep(math.random(RapidFireSleepMin, RapidFireSleepMax))
    until not IsMouseButtonPressed(RC)
end

function NoRecoil()
    repeat
        MoveMouseRelative(HorizontalRecoilModifier, ActiveRecoil)
        Sleep(math.random(SleepNoRecoilMin, SleepNoRecoilMax))
    until not IsMouseButtonPressed(LC)
end

function OnEvent(event, arg)
    EnablePrimaryMouseButtonEvents(true)

    if event == "MOUSE_BUTTON_PRESSED" and arg == 9 then
        CurrentProfile = CurrentProfile + 1
        if CurrentProfile > #Profiles then CurrentProfile = 1 end
        LoadProfile(CurrentProfile)
    end

    if event == "MOUSE_BUTTON_PRESSED" and arg == LC then
        Sleep(25)
        if IsMouseButtonPressed(RC) and IsKeyLockOn(LockKey) then
            NoRecoil()
            Resetter()
        else
            while IsMouseButtonPressed(LC) do
                Sleep(15)
                if IsMouseButtonPressed(RC) and IsKeyLockOn(LockKey) then
                    NoRecoil()
                    Resetter()
                end
            end
        end
    end

    if event == "MOUSE_BUTTON_PRESSED" and arg == RapidFireButton then
        Sleep(25)
        if IsMouseButtonPressed(RC) then
            RapidFire()
            Resetter()
        end
    end
end
