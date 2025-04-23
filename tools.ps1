          # Create tools directory
          $ToolsDir = "C:\Tools"
          New-Item -Path $ToolsDir -ItemType Directory -Force | Out-Null

          # Download PuTTY and Chrome
          [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

          $PuttyUrl = "https://the.earth.li/~sgtatham/putty/latest/w64/putty-64bit-0.83-installer.msi"
          $ChromeUrl = "https://dl.google.com/chrome/install/latest/chrome_installer.exe"
          $PuttyInstaller = "$ToolsDir\putty.msi"
          $ChromeInstaller = "$ToolsDir\chrome_installer.exe"
          Invoke-WebRequest -Uri $PuttyUrl -OutFile $PuttyInstaller
          Invoke-WebRequest -Uri $ChromeUrl -OutFile $ChromeInstaller

          # Install PuTTY and Chrome
          Start-Process "msiexec.exe" -ArgumentList "/i `"$PuttyInstaller`" /qn /norestart" -Wait
          Start-Process "$ChromeInstaller" -ArgumentList "/silent /install" -Wait
          #Download SSMS
          #Invoke-WebRequest -Uri "https://aka.ms/ssmsfullsetup" -OutFile "C:\Tools\SSMS-Setup.exe"
          #Start-Process -FilePath "C:\Tools\SSMS-Setup.exe" -ArgumentList "/install", "/quiet", "/norestart" -Wait

          # Download Key
          $Url = "https://trendmicro-my.sharepoint.com/:u:/p/rommel_munoz/EUykZu2q8oxHmqkFLcODKCIBFruhCSj1bD8RmjU46DaDSw?download=1"
          $ToolsDir = "C:\tools"
          $OutputFile = "trendmicro-sg-key.zip"
          $OutputPath = Join-Path $ToolsDir $OutputFile

          [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

          try {
               Invoke-WebRequest -Uri $Url -OutFile $OutputPath -UseBasicParsing -ErrorAction Stop
               Write-Host "Downloaded successfully to $OutputPath"
          } catch {
            Write-Host "Download failed: $_"
            "$_" | Out-File "$ToolsDir\download-error.txt"
          }
