build {
  sources = [
    "source.azure-arm.windows"
  ]

    provisioner "file" {
      source = "packer/copy.ps1"
      destination = "c:\\copy.ps1"
    }
    
    provisioner "powershell"{
      inline = ["cd c:/"]
    }

    provisioner "powershell"{
      scripts = ["./packer/copy.ps1"]
    }

    provisioner "windows-restart" {
      restart_check_command = "powershell -command \"& {Write-Output 'Windows Restarted.'}\""
    }

    provisioner "powershell" {
      inline = [
        "& $env:SystemRoot\\System32\\Sysprep\\Sysprep.exe /oobe /generalize /quiet /quit",
        "while($true) { $imageState = Get-ItemProperty HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Setup\\State | Select ImageState; if($imageState.ImageState -ne 'IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE') { Write-Output $imageState.ImageState; Start-Sleep -s 10  } else { break } }"
      ]
    }
}