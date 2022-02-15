#Proof-of-concept:
#(New-Object Media.SoundPlayer "c:\users\$($env:username)\documents\github\talking-clock\source\sound\bang.wav").Play();
#(New-Object Media.SoundPlayer "$($psscriptroot)\sound\bang.wav").Play();

# Usage:
# pwsh -file /usr/share/talking-clock/source/talking-clock-ps.ps1
# pwsh -file /usr/share/talking-clock/source/talking-clock-ps.ps1 -ChimeStartHour 8 -ChimeEndHour 19 -Frequency 60
# pwsh -file /usr/share/talking-clock/source/talking-clock-ps.ps1 -ChimeStartHour 8 -ChimeEndHour 19 -Frequency 30 -SecondHand 1

# Parameters:
# [Optional] Chime Start Hour: What hour (24h) to start chiming. If no flag specified, default is 0800 hours
# [Optional] Chime End Hour: What hour (24h) to end chiming. If no flag specified, default is 1900 hours
# [Optional] Frequency: Frequency of chimes (example: 15, 30, 60). If no flag specified clock will play every 15 minutes and performa full chime at the full
# [Optional] Second Hand: Play audible second hand ticks, with options for various sounds if not specified, it will be off. 0 = none [default] 1 = Sessions clock tick. 2 = Foyer clock tick. 3 = Seth Thomas clock tick 1. 4 = Seth Thomas clock tick 2.

Param (
    [Parameter()]
    [Int32]$ChimeStartHour,
    [Parameter()]
    [Int32]$ChimeEndHour,
    [Parameter()]
    [Int32]$Frequency,
    [Parameter()]
    [Int32]$SecondHand
)

if(!$ChimeStartHour){
    $ChimeStartHour = 8
}

if(!$ChimeEndHour){
    $ChimeEndHour = 19
}

if(!$Frequency){
    $Frequency = 60
}

if(!$SecondHand){
    $SecondHand = 0
}

write-warning "Chime hours defined as $($ChimeStartHour) to $($ChimeEndHour), with frequency of $($Frequency). Second hand style: $($SecondHand). Waiting till the top of the minute to begin."

while( (get-date).ToString("ss") -ne '00' ){
    #write-debug "Waiting until we're at 0 seconds in the minute before we begin"
    start-sleep 1 # To be nice to the CPU
}

$run                = $true
$BigChime           = "unhhourly.wav"
$SmallChime         = "bang.wav"

if($SecondHand -eq 0){
    #n/a
}elseif($SecondHand -eq 1){
    $SecondHandTick = "sessionsclocktick.wav"
}elseif($SecondHand -eq 2){
    $SecondHandTick = "foyerclocktick.wav"
}elseif($SecondHand -eq 3){
    $SecondHandTick = "seththomasclocktick1.wav"
}elseif($SecondHand -eq 4){
    $SecondHandTick = "seththomasclocktick2.wav"
}else{
    write-error "Invalid second hand option."
    exit
}

$BigChimePlayed     = $false
$HourlyBongsPlayed  = $false
$SmallChimePlayed   = $false

Write-Warning "Script has begun"

#region Play second hand ticks in a separate background job (but only if specified)
if($SecondHand -ge 1){
    Write-Warning "Activating second hand"
    if($IsLinux -eq $true){
        Start-Job{
            while($using:run -eq $true){
                aplay -q "$using:psscriptroot/sound/$($using:SecondHandTick)"
            }
        }|Out-Null
    }elseif($IsMacOS -eq $true){
        #TODO: TBD
    }else{
        #Windows
        start-job{
            while($using:run -eq $true){
                (New-Object Media.SoundPlayer "$($psscriptroot)\sound\$($SecondHandTick)").Play();
            }
        }|Out-Null
    }
}
#endregion

while($run -eq $true){

    $date               = get-date
    $CurrentHour24H     = $date.ToString("HH")
    $CurrentHour12H     = $date.ToString("hh")
    $CurrentMinute      = $date.ToString("mm")
    #$CurrentSecond      = $date.ToString("ss")

    #Write-Warning "$($currenthour24h):$($currentminute)"

    if($CurrentMinute -eq '00'){

        #Only chime if between certain hours
        if ( ([Int32]$CurrentHour24H -ge $ChimeStartHour) -and ([Int32]$CurrentHour24H -le $ChimeEndHour) ){
            #region play the big hourly chime
            if($BigChimePlayed -eq $false){
                Write-Warning "$($CurrentHour24H):$($CurrentMinute) Chime"
                if($IsLinux -eq $true){
                    aplay -q "$psscriptroot/sound/$($BigChime)"
                }elseif($IsMacOS -eq $true){
                    #TODO: TBD
                }else{
                    #Windows
                    (New-Object Media.SoundPlayer "$($psscriptroot)\sound\$($BigChime)").Play();
                    start-sleep 25 #To prevent overlapping over the next wav file
                }
                $BigChimePlayed = $true
            }
            #endregion

            #region play the chime x times based on the hour, shorten all but the last one
            if($HourlyBongsPlayed -eq $false){
                Write-Warning "Bong x$($CurrentHour12H)"
                for($c=1; $c -le $CurrentHour12H; $c++){
                    if( ($c -ne $CurrentHour12H) ){
                        #Play the bang abridged
                        if($IsLinux -eq $true){
                            aplay -q "$psscriptroot/sound/$($SmallChime)" -d 3
                        }elseif($IsMacOS -eq $true){
                            #TODO: TBD
                        }else{
                            #Windows
                            (New-Object Media.SoundPlayer "$($psscriptroot)\sound\$($SmallChime)").Play();
                            start-sleep 3.5
                        }

                    }else{
                        #Play the final bang unabridged
                        if($IsLinux -eq $true){
                            aplay -q "$psscriptroot/sound/$($SmallChime)"
                        }elseif($IsMacOS -eq $true){
                            #TODO: TBD
                        }else{
                            #Windows
                            (New-Object Media.SoundPlayer "$($psscriptroot)\sound\$($SmallChime)").Play();
                        }
                    }
                }
                $HourlyBongsPlayed = $true
            }
            #endregion
        }

    }elseif( ($CurrentMinute -eq '15') ){

        if($Frequency -le 15){
            #region Only small chime if between certain hours
            if ( ([Int32]$CurrentHour24H -ge $ChimeStartHour) -and ([Int32]$CurrentHour24H -le $ChimeEndHour) ){

                if($SmallChimePlayed -eq $false){
                    Write-Warning "$($CurrentHour24H):$($CurrentMinute) Chime 15min"
                    #Play the bang unabridged
                    if($IsLinux -eq $true){
                        aplay -q "$psscriptroot/sound/$($SmallChime)"
                    }elseif($IsMacOS -eq $true){
                        #TODO: TBD
                    }else{
                        #Windows
                        (New-Object Media.SoundPlayer "$($psscriptroot)\sound\$($SmallChime)").Play();
                    }
                    $SmallChimePlayed = $True
                }
            }
            #endregion

        }else{
            write-debug "Not playing 15min chime, frequency is set to be $($Frequency)"
            #start-sleep (59-$CurrentSecond) #To prevent console spam
        }

    }elseif( ($CurrentMinute -eq '30') ){

        if($Frequency -le 30){
            #region Only small chime if between certain hours
            if ( ([Int32]$CurrentHour24H -ge $ChimeStartHour) -and ([Int32]$CurrentHour24H -le $ChimeEndHour) ){

                if($SmallChimePlayed -eq $false){
                    Write-Warning "$($CurrentHour24H):$($CurrentMinute) Chime 30min"
                    #Play the bang unabridged
                    if($IsLinux -eq $true){
                        aplay -q "$psscriptroot/sound/$($SmallChime)"
                    }elseif($IsMacOS -eq $true){
                        #TODO: TBD
                    }else{
                        #Windows
                        (New-Object Media.SoundPlayer "$($psscriptroot)\sound\$($SmallChime)").Play();
                    }
                    $SmallChimePlayed = $True
                }
            }
            #endregion

        }else{
            Write-Debug "Not playing 30min chime, frequency is set to be $($Frequency)"
            #start-sleep (59-$CurrentSecond) #To prevent console spam
        }

    }elseif( ($CurrentMinute -eq '45') ){

        if($Frequency -ge 45){
            #region Only chime if between certain hours
            if ( ([Int32]$CurrentHour24H -ge $ChimeStartHour) -and ([Int32]$CurrentHour24H -le $ChimeEndHour) ){

                if($SmallChimePlayed -eq $false){
                    Write-Warning "$($CurrentHour24H):$($CurrentMinute) Chime 45min"
                    #Play the bang unabridged
                    if($IsLinux -eq $true){
                        aplay -q "$psscriptroot/sound/$($SmallChime)"
                    }elseif($IsMacOS -eq $true){
                        #TODO: TBD
                    }else{
                        #Windows
                        (New-Object Media.SoundPlayer "$($psscriptroot)\sound\$($SmallChime)").Play();
                    }
                    $SmallChimePlayed = $true
                }
            }
            #endregion

        }else{
            Write-Debug "Not playing 45min chime, frequency is set to be $($Frequency)"
        }

    }else{
        # (current minute does not trigger any chimes)
        #Reset chime flag
        $BigChimePlayed = $false
        $SmallChimePlayed = $false
        $HourlyBongsPlayed = $false
    }

    start-sleep 1 # To be nice to the CPU

}