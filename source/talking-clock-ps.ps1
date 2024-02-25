#Proof-of-concept:
#(New-Object Media.SoundPlayer "c:\users\$($env:username)\documents\github\talking-clock\source\sound\bang.wav").Play();
#(New-Object Media.SoundPlayer "$($psscriptroot)\sound\bang.wav").Play();

# Usage:
# pwsh -file /usr/share/talking-clock/source/talking-clock-ps.ps1
# pwsh -file /usr/share/talking-clock/source/talking-clock-ps.ps1 -ChimeStartHr 9 -ChimeEndHr 17 -Freq 60
# pwsh -file /usr/share/talking-clock/source/talking-clock-ps.ps1 -ChimeStartHr 9 -ChimeEndHr 17 -Freq 30 -SecondHnd 0 -BgChime 1 -SmlChime 1

#region file parameter definitions
#Had to make these a bit weird to stay out of conflict with var names in the actual function
Param (
    [Parameter()]
    [Int32]$ChimeStartHr,
    [Parameter()]
    [Int32]$ChimeEndHr,
    [Parameter()]
    [Int32]$Freq,
    [Parameter()]
    [Int32]$SecondHnd,
    [Parameter()]
    [Int32]$BgChime,
    [Parameter()]
    [Int32]$SmlChime
)

if(!$ChimeStartHr){
    $ChimeStartHr = 9
}

if(!$ChimeEndHr){
    $ChimeEndHr = 17
}

if(!$Freq){
    $Freq = 30
}

if(!$SecondHnd){
    $SecondHnd = 0
}

if(!$BgChime){
    $BgChime = 1
}

if(!$SmlChime){
    $SmlChime = 1
}
#endregion

<#
.Synopsis
    QA Status: Partially tested on Windows/Linux. macOS untested
    Author: Steve K
    Simulate a wall or tower clock.
.DESCRIPTION
    Simulate a wall or tower clock.
.EXAMPLE
    Invoke-ChimeClock -ChimeStartHour 8 -ChimeEndHour 19 -Frequency 60 -SecondHandStyle 0 -BigChimeStyle 1 -SmallChimeStyle 1
.INPUTS
    Start hour, end hour, frequency, second hand style, big chime style, small chime style
.OUTPUTS
    Audio
.PARAMETER ChimeStartHour
    Chime Start Hour: What hour (24h) to start chiming.
    If no flag specified, default is 0800 hours
.PARAMETER ChimeEndHour
    Chime End Hour: What hour (24h) to end chiming.
    If no flag specified, default is 1900 hours
.PARAMETER Frequency
    Frequency: Frequency of chimes (example: 15, 30, 60).
    If no flag specified clock will play every 15 minutes and performa full chime at the full
.PARAMETER SecondHandStyle
    Second Hand: Play audible second hand ticks, with options for various sounds if not specified, it will be off.
    0 = None
    1 = Sessions clock tick.
    2 = Korea clock tick.
    3 = Seth Thomas clock tick 1.
    4 = Seth Thomas clock tick 2.
    5 = Waterbury clock tick
.PARAMETER BigChimeStyle
    The audio played before the number of hourly "bongs"
    0 = None
    1 = UNH Thompson Hall Tower Westminster Chime
.PARAMETER SmallChimeStyle
    The "bongs" which represent what hour it is.
    Played at the top of the hour and at 15/30/45 minutes (based on Frequency param)
    0 = None
    1 = UNH Thompson Hall Tower
    2 = Korea [TODO: implement this]
    3 = Waterbury [TODO: implement this]
    4 = Cuckoo Clock
.NOTES
    Version: 1.1.1
.COMPONENT
    N/A
.ROLE
    No idea
.FUNCTIONALITY
    Fun
#>
function Invoke-ChimeClock
{
    [CmdletBinding(DefaultParameterSetName='Set 1',
                  SupportsShouldProcess=$true,
                  PositionalBinding=$false,
                  HelpUri = 'https://www.duckduckgo.com/',
                  ConfirmImpact="Medium")]
    [Alias()]
    [OutputType([String])]
    Param
    (
        # Chime Start Hour Param
        [Parameter(Mandatory=$true,
                   Position=0,
                   ParameterSetName='Set 1')]
        [ValidateNotNullOrEmpty()]
        [ValidateSet(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23)]
        [Int32]$ChimeStartHour,

        # Chime Start Hour Param
        [Parameter(Mandatory=$true,
                   Position=1,
                   ParameterSetName='Set 1')]
        [ValidateNotNullOrEmpty()]
        [ValidateSet(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23)]
        [Int32]$ChimeEndHour,

        # Frequency Param
        [Parameter(Mandatory=$true,
                   Position=2,
                   ParameterSetName='Set 1')]
        [ValidateNotNullOrEmpty()]
        [ValidateSet(15,30,60)]
        [Int32]$Frequency,

        # SecondHandStyle Param
        [Parameter(Mandatory=$true,
                   Position=3,
                   ParameterSetName='Set 1')]
        [ValidateNotNullOrEmpty()]
        [ValidateSet(0,1,2,3,4,5)]
        [string]$SecondHandStyle,

        # BigChimeStyle Param
        [Parameter(Mandatory=$true,
                   Position=4,
                   ParameterSetName='Set 1')]
        [ValidateNotNullOrEmpty()]
        [ValidateSet(0,1)]
        [string]$BigChimeStyle,

        # SmallChimeStyle Param
        [Parameter(Mandatory=$true,
                   Position=5,
                   ParameterSetName='Set 1')]
        [ValidateNotNullOrEmpty()]
        [ValidateSet(0,1,2,3,4)]
        [string]$SmallChimeStyle

    )

    Begin{}

    Process{
        if ($pscmdlet.ShouldProcess("Chime Clock", "Start")){
            write-verbose "Chime hours defined as $($ChimeStartHour) to $($ChimeEndHour), with frequency of $($Frequency). Second hand style: $($SecondHandStyle). Big Chime style: $($BigChimeStyle). Small Chime style: $($SmallChimeStyle). Waiting till the top of the minute to begin."

            #region Prep work
            while( (get-date).ToString("ss") -ne '00' ){
                write-debug "Waiting until we're at 0 seconds in the minute before we begin"
                start-sleep 1 # To be nice to the CPU
            }

            $run = $true

            if($SecondHand -eq 0){
                $SecondHandTick = ''
            }elseif($SecondHandStyle -eq 1){
                $SecondHandTick = 'sessionsclocktick.wav'
            }elseif($SecondHandStyle -eq 2){
                $SecondHandTick = 'koreaclocktick.wav'
            }elseif($SecondHandStyle -eq 3){
                $SecondHandTick = 'seththomasclocktick1.wav'
            }elseif($SecondHandStyle -eq 4){
                $SecondHandTick = 'seththomasclocktick2.wav'
            }elseif($SecondHandStyle -eq 5){
                $SecondHandTick = 'waterburyclocktick.wav'
            }

            if($BigChimeStyle -eq 0){
                $BigChime = ''
            }elseif($BigChimeStyle -eq 1){
                $BigChime = 'unhhourly.wav'
            }

            if($SmallChimeStyle -eq 0){
                $BigChime = ''
            }elseif($SmallChimeStyle -eq 1){
                $SmallChime = 'bangthall.wav'
            }elseif($SmallChimeStyle -eq 2){
                $SmallChime = 'bangkorea.wav'
            }elseif($SmallChimeStyle -eq 3){
                $SmallChime = 'bangwaterbury.wav'
            }elseif($SmallChimeStyle -eq 4){
                $SmallChime = 'bangcuckoo.wav'
            }
            #endregion

            #region Let's go
            $BigChimePlayed     = $false
            $HourlyBongsPlayed  = $false
            $SmallChimePlayed   = $false

            Write-Verbose "Script has begun"

            #region Play second hand ticks in a separate background job (but only if specified)
            if($SecondHandStyle -ge 1){
                Write-Verbose "Activating second hand"
                if($IsLinux -eq $true){
                    Start-Job{
                        while($using:run -eq $true){
                            aplay -q "$using:psscriptroot/sound/$($using:SecondHandTick)"
                        }
                    }|Out-Null
                }elseif($IsMacOS -eq $true){
                    Start-Job{
                        while($using:run -eq $true){
                            afplay "$using:psscriptroot/sound/$($using:SecondHandTick)"
                        }
                    }|Out-Null
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

                #Write-Verbose "$($currenthour24h):$($currentminute)"

                if($CurrentMinute -eq '00'){

                    #Only chime if between certain hours
                    if ( ([Int32]$CurrentHour24H -ge $ChimeStartHour) -and ([Int32]$CurrentHour24H -le $ChimeEndHour) ){
                        #region play the big hourly chime
                        if($BigChimePlayed -eq $false){
                            Write-Verbose "$($CurrentHour24H):$($CurrentMinute) Chime"
                            if($IsLinux -eq $true){
                                aplay -q "$psscriptroot/sound/$($BigChime)"
                            }elseif($IsMacOS -eq $true){
                                afplay "$psscriptroot/sound/$($BigChime)"
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

                            for($c=1; $c -le $CurrentHour12H; $c++){
                                if( ($c -ne $CurrentHour12H) ){
                                    #Play the bang abridged
                                    Write-Verbose "Bong x$($CurrentHour12H)"
                                    if($IsLinux -eq $true){
                                        aplay -q "$psscriptroot/sound/$($SmallChime)" -d 3
                                    }elseif($IsMacOS -eq $true){
                                        afplay "$psscriptroot/sound/$($SmallChime)"
                                        start-sleep 3.5
                                    }else{
                                        #Windows
                                        (New-Object Media.SoundPlayer "$($psscriptroot)\sound\$($SmallChime)").Play();
                                        start-sleep 3.5
                                    }

                                }else{
                                    #Play the final bang unabridged
                                    Write-Verbose "Bong x$($CurrentHour12H) unabridged"
                                    if($IsLinux -eq $true){
                                        aplay -q "$psscriptroot/sound/$($SmallChime)"
                                    }elseif($IsMacOS -eq $true){
                                        afplay "$psscriptroot/sound/$($SmallChime)"
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
                                Write-Verbose "$($CurrentHour24H):$($CurrentMinute) Chime 15min"
                                #Play the bang unabridged
                                if($IsLinux -eq $true){
                                    aplay -q "$psscriptroot/sound/$($SmallChime)"
                                }elseif($IsMacOS -eq $true){
                                    afplay "$psscriptroot/sound/$($SmallChime)"
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
                                Write-Verbose "$($CurrentHour24H):$($CurrentMinute) Chime 30min"
                                #Play the bang unabridged
                                if($IsLinux -eq $true){
                                    aplay -q "$psscriptroot/sound/$($SmallChime)"
                                }elseif($IsMacOS -eq $true){
                                    afplay "$psscriptroot/sound/$($SmallChime)"
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
                                Write-Verbose "$($CurrentHour24H):$($CurrentMinute) Chime 45min"
                                #Play the bang unabridged
                                if($IsLinux -eq $true){
                                    aplay -q "$psscriptroot/sound/$($SmallChime)"
                                }elseif($IsMacOS -eq $true){
                                    afplay "$psscriptroot/sound/$($SmallChime)"
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
            #endregion

        }
    }

    End{}
}

Invoke-ChimeClock -Verbose -ChimeStartHour $ChimeStartHr -ChimeEndHour $ChimeEndHr -Frequency $Freq -SecondHandStyle $SecondHnd -BigChimeStyle $BgChime -SmallChimeStyle $SmlChime
