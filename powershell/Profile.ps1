#
# Pheo's ~/Documents/WindowPowerShell/Profile.ps1
#
function NeoVim {
    param ($Parameter1 = '')
    nvim "$parameter1"
}

New-Alias -Name vim -Value NeoVim
