# Functions

Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip
{
    param([string]$zipfile, [string]$outpath)

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}

function DownloadFile
{
    param($downloadUrl, $output, $description)
    Write-Host "$description indiriliyor..."
    Invoke-WebRequest -Uri $downloadUrl -OutFile $output
}



while ($true) {
    Write-Host "yapimci bahadir araz :)"
    Write-Output instagram bahadiraraz2
    $bbbUrl = Read-Host -Prompt 'video linkini giriniz'
    $resultFileName = Read-Host -Prompt 'video kayit isimi'
    $resultFileName += ".mp4"
    $parts = $bbbUrl -split "presentation/2.3/"
    $ID = $parts[1] -split "AccessToken"
    $ID  = $ID[0]
    $ID = $ID -replace '[?]'
    $bbbHost = $parts[0] -split "/playback"
    $bbbHost = $bbbHost[0]
   
    Write-Host "ID: $ID"
    Write-Host "BBB-Host: $bbbHost"

    # sesi indirme

    $webcamsUrl = "$bbbHost/presentation/$ID/video/webcams.mp4"
    $output = "webcams.mp4"

    DownloadFile $webcamsUrl $output "ses"

    # goruntu indirme

    $deskshareUrl = "$bbbHost/presentation/$ID/deskshare/deskshare.mp4"
    $output = "deskshare.mp4"

    DownloadFile $deskshareUrl $output "video"

    # FFMPEG yok ise yukle

    $ffmpegPath = ".\ffmpeg.exe"
    $ffmpegVersion = "4.3.1-2020-11-08"

    if (Test-Path($ffmpegPath)) {
        Write-Host "$ffmpegPath, hazida indirili"
        Write-Host "islem baslatiliyor..."
    } else {
        $ffmpegUrl = "https://github.com/GyanD/codexffmpeg/releases/download/$ffmpegVersion/ffmpeg-$ffmpegVersion-full_build.zip"
        $output = "ffmpeg.zip"

        DownloadFile $ffmpegUrl $output "ffmpeg.zip"

        # Unzipping and moving

        Write-Host "disa aktariliyor ffmpeg.zip..."
        Unzip ".\$output" "."

        Write-Host "yer degistiriliyor ffmpeg.exe..."
        Move-Item -Path ".\ffmpeg-$ffmpegVersion-full_build\bin\ffmpeg.exe" -Destination "."

        Write-Host "siliniyor ffmpeg.zip..."
        Remove-Item -Recurse -Force ".\ffmpeg-$ffmpegVersion-full_build"
        Remove-Item -Force ".\ffmpeg.zip"
    }

    # Convert to one videofile

    Write-Host "ses ve goruntu birlestiriliyor..."
    Invoke-Expression ".\ffmpeg.exe -loglevel quiet -i webcams.mp4 -i deskshare.mp4 -c copy $resultFileName"
    #delete webcams.mp4 deskshare.mp4
    Write-Host "islem tamamlandi."
    Write-Host ""
    $host.UI.RawUI.ClearHost
    $host.UI.RawUI.Clear
}
