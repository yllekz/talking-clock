#Proof-of-concept:
#(New-Object Media.SoundPlayer "c:\users\$($env:username)\documents\github\talking-clock\source\sound\bang.wav").Play();
#(New-Object Media.SoundPlayer "$($psscriptroot)\sound\bang.wav").Play();

# Usage:
# pwsh -file /usr/share/talking-clock/source/talking-clock-ps.ps1
# pwsh -file /usr/share/talking-clock/source/talking-clock-ps.ps1 -ChimeStartHour 8 -ChimeEndHour 19 -Frequency 60
# pwsh -file /usr/share/talking-clock/source/talking-clock-ps.ps1 -ChimeStartHour 8 -ChimeEndHour 19 -Frequency 60 -SecondHand

# Parameters:
# [Optional] Chime Start Hour: What hour (24h) to start chiming. If no flag specified, default is 0800 hours
# [Optional] Chime End Hour: What hour (24h) to end chiming. If no flag specified, default is 1900 hours
# [Optional] Frequency: Frequency of chimes (example: 15, 30, 60). If no flag specified clock will play every 15 minutes and performa full chime at the full
# [Optional] Second Hand: Play audible second hand ticks. Default is false.

Param (
    [Parameter()]
    [String]$ChimeStartHour,
    [Parameter()]
    [String]$ChimeEndHour,
    [Parameter()]
    [Int32]$Frequency,
    [Parameter()]
    [switch]$SecondHand
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
    $SecondHand = $false
}

write-warning "Chime hours defined as $($ChimeStartHour) to $($ChimeEndHour), with frequency of $($Frequency). Play seconds? $($SecondHand). Waiting till the top of the minute to begin."

while( (get-date).ToString("ss") -ne '00' ){
    #write-debug "Waiting until we're at 0 seconds in the minute before we begin"
    start-sleep 1 # To be nice to the CPU
}

$run = $true
Write-Warning "Script has begun"

while($run -eq $true){

    $date               = get-date
    $CurrentHour24H     = $date.ToString("HH")
    $CurrentHour12H     = $date.ToString("hh")
    $CurrentMinute      = $date.ToString("mm")
    #$CurrentSecond      = $date.ToString("ss")
    $BigChime           = "unhhourly.wav"
    $SmallChime         = "bang.wav"
    $SecondHandTick     = "sessionsclocktick.wav"

    #Write-Warning "$($currenthour24h):$($currentminute)"

    if($CurrentMinute -eq '00'){

        #Only chime if between certain hours
        if ( $CurrentHour24H -ge $ChimeStartHour -or $CurrentHour24H -le $ChimeEndHour ){
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

            #play the chime x times based on the hour, shorten all but the last one
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
                    #Play the bang unabridged
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
        }

        start-sleep 35 #To prevent it from going off again in the same minute

    }elseif( ($CurrentMinute -eq '15') ){

        if($Frequency -le 15){
            #Only chime if between certain hours
            if ( $CurrentHour24H -ge $ChimeStartHour -or $CurrentHour24H -le $ChimeEndHour ){
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
            }

            start-sleep 60 #To prevent it from going off again in the same minute
        }else{
            write-debug "Not playing 15min chime, frequency is set to be $($Frequency)"
            #start-sleep 60 #To prevent console spam
        }

    }elseif( ($CurrentMinute -eq '30') ){

        if($Frequency -le 30){
            #Only chime if between certain hours
            if ( $CurrentHour24H -ge $ChimeStartHour -or $CurrentHour24H -le $ChimeEndHour ){
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
            }

            start-sleep 60 #To prevent it from going off again in the same minute
        }else{
            Write-Debug "Not playing 30min chime, frequency is set to be $($Frequency)"
            #start-sleep 60 #To prevent console spam
        }

    }elseif( ($CurrentMinute -eq '45') ){

        if($Frequency -le 30){
            #Only chime if between certain hours
            if ( $CurrentHour24H -ge $ChimeStartHour -or $CurrentHour24H -le $ChimeEndHour ){
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
            }

            start-sleep 60 #To prevent it from going off again in the same minute
        }else{
            Write-Debug "Not playing 45min chime, frequency is set to be $($Frequency)"
            #start-sleep 60 #To prevent console spam
        }

    }else{
        #Play second hand ticks (but only if specified)
        if($SecondHand -eq $true){
            if($IsLinux -eq $true){
                aplay -q "$psscriptroot/sound/$($SecondHandTick)"
            }elseif($IsMacOS -eq $true){
                #TODO: TBD
            }else{
                #Windows
                (New-Object Media.SoundPlayer "$($psscriptroot)\sound\$($SecondHandTick)").Play();
            }
        }
    }

    start-sleep 1 # To be nice to the CPU

}