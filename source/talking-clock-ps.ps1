#Proof-of-concept:
#(New-Object Media.SoundPlayer "c:\users\$($env:username)\documents\github\talking-clock\source\sound\bang.wav").Play();
#(New-Object Media.SoundPlayer "$($psscriptroot)\sound\bang.wav").Play();

while( (get-date).ToString("ss") -ne '00' ){
    #write-debug "Waiting until we're at 0 seconds in the minute before we begin"
    start-sleep 1 # To be nice to the CPU
}

$run = $true
Write-Warning "Script has begun"

$ChimeStartHour = 8
$ChimeEndHour = 19

write-warning "Chime hours defined as $($ChimeStartHour) to $($ChimeEndHour)"

while($run -eq $true){

    $date               = get-date
    $CurrentHour24H     = $date.ToString("HH")
    $CurrentHour12H     = $date.ToString("hh")
    $CurrentMinute      = $date.ToString("mm")
    #$CurrentSecond      = $date.ToString("ss")

    #Write-Warning "$($currenthour24h):$($currentminute)"

    if($CurrentMinute -eq '00'){

        #Only chime if between certain hours
        if ( $CurrentHour24H -ge $ChimeStartHour -or $CurrentHour24H -le $ChimeEndHour ){
            Write-Warning "$($CurrentHour24H):$($CurrentMinute) Chime"
            
            if($IsLinux -eq $true){
                aplay -q "$psscriptroot/sound/unhhourly.wav"
            }elseif($IsMacOS -eq $true){
                #TODO: TBD
            }else{
                #Windows
                (New-Object Media.SoundPlayer "$($psscriptroot)\sound\unhhourly.wav").Play();
                start-sleep 25 #To prevent overlapping over the next wav file
            }

            #play the chime x times based on the hour, shorten all but the last one
            for($c=1; $c -le $CurrentHour12H; $c++){
                Write-Warning "Bong x$($CurrentHour12H)"                
                if( ($c -ne $CurrentHour12H) ){
                    #Play the bang abridged
                    if($IsLinux -eq $true){
                        aplay -q "$psscriptroot/sound/bang.wav" -d 3
                    }elseif($IsMacOS -eq $true){
                        #TODO: TBD
                    }else{
                        #Windows
                        (New-Object Media.SoundPlayer "$($psscriptroot)\sound\bang.wav").Play();
                        start-sleep 3.5
                    }
        
                }else{
                    #Play the bang unabridged
                    if($IsLinux -eq $true){
                        aplay -q "$psscriptroot/sound/bang.wav"
                    }elseif($IsMacOS -eq $true){
                        #TODO: TBD
                    }else{
                        #Windows
                        (New-Object Media.SoundPlayer "$($psscriptroot)\sound\bang.wav").Play();
                    }
                }
            }
        }

        start-sleep 35 #To prevent it from going off again in the same minute

    }elseif( ($CurrentMinute -eq '15') ){

        #Only chime if between certain hours
        if ( $CurrentHour24H -ge $ChimeStartHour -or $CurrentHour24H -le $ChimeEndHour ){
            Write-Warning "$($CurrentHour24H):$($CurrentMinute) Chime 15min"
            #Play the bang unabridged
            if($IsLinux -eq $true){
                aplay -q "$psscriptroot/sound/bang.wav"
            }elseif($IsMacOS -eq $true){
                #TODO: TBD
            }else{
                #Windows
                (New-Object Media.SoundPlayer "$($psscriptroot)\sound\bang.wav").Play();
            }
        }

        start-sleep 60 #To prevent it from going off again in the same minute

    }elseif( ($CurrentMinute -eq '30') ){

        #Only chime if between certain hours
        if ( $CurrentHour24H -ge $ChimeStartHour -or $CurrentHour24H -le $ChimeEndHour ){
            Write-Warning "$($CurrentHour24H):$($CurrentMinute) Chime 30min"
            #Play the bang unabridged
            if($IsLinux -eq $true){
                aplay -q "$psscriptroot/sound/bang.wav"
            }elseif($IsMacOS -eq $true){
                #TODO: TBD
            }else{
                #Windows
                (New-Object Media.SoundPlayer "$($psscriptroot)\sound\bang.wav").Play();
            }
        }

        start-sleep 60 #To prevent it from going off again in the same minute

    }elseif( ($CurrentMinute -eq '45') ){

        #Only chime if between certain hours
        if ( $CurrentHour24H -ge $ChimeStartHour -or $CurrentHour24H -le $ChimeEndHour ){
            Write-Warning "$($CurrentHour24H):$($CurrentMinute) Chime 45min"
            #Play the bang unabridged
            if($IsLinux -eq $true){
                aplay -q "$psscriptroot/sound/bang.wav"
            }elseif($IsMacOS -eq $true){
                #TODO: TBD
            }else{
                #Windows
                (New-Object Media.SoundPlayer "$($psscriptroot)\sound\bang.wav").Play();
            }
        }

        start-sleep 60 #To prevent it from going off again in the same minute

    }

    start-sleep 1 # To be nice to the CPU

}