#
# Pheo's $profile
# ie. ~/Documents/PowerShell/Microsoft.PowerShell_profile.ps1
#

Set-PSReadlineOption -EditMode vi # vi instead of emacs
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete # tab completion

# nvim
function NeoVim {
    param ($Parameter1 = '')
    nvim "$parameter1"
}

New-Alias -Name vim -Value NeoVim

# Ctrl+B to run in bash
Set-PSReadLineKeyHandler -Chord Ctrl+b -ScriptBlock {
  $line = $null
  $cursor = $null
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

  $line = $line.Replace("\", "/")

  [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
  [Microsoft.PowerShell.PSConsoleReadLine]::Insert("bash " + $line)
  [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}

function List-Wide
{
    Get-ChildItem | Format-Wide -Column 5
}
Set-Alias -Name lsw -Value List-Wide

# starship
Invoke-Expression (&starship init powershell)

# configs
$NVIMRC = "$HOME\AppData\Local\nvim\init.vim"
$GLAZECONFIG = "$HOME\.glaze-wm\config.yaml"
$STARSHIPTOML = "$HOME\.config\starship.toml"
