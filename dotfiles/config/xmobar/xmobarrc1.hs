-- http://projects.haskell.org/xmobar/
-- install xmobar with these flags: --flags="with_alsa" --flags="with_mpd" --flags="with_xft"  OR --flags="all_extensions"
-- you can find weather location codes here: http://weather.noaa.gov/index.html

Config { font    = "xft:Ubuntu:weight=medium:pixelsize=14:antialias=true:hinting=true"
       , additionalFonts = [ "xft:Mononoki Nerd Font:pixelsize=14:antialias=true:hinting=true"
                           , "xft:FontAwesome:pixelsize=14"
                           ]
       , bgColor = "#282c34"
       , fgColor = "#ff6c6b"
       --, position = Static { xpos = 0 , ypos = 0, width = 1900, height = 28 }
       , position = Top
       , lowerOnStart = True
       , hideOnStart = False
       , allDesktops = True
       , persistent = True
       , iconRoot = "/home/dt/.xmonad/xpm/"  -- default: "."
       , commands = [
                      -- Time and date
                      Run Date "%b %d %Y - (%H:%M) " "date" 50
                      -- Network up and down
                    , Run Network "wlp0s20f3" ["-t", "down: <rx>kb  up:  <tx>kb"] 20
                      -- Cpu usage in percent
                    , Run Cpu ["-t", "cpu: (<total>%)","-H","50","--high","red"] 20
                      -- Ram used number and percent
                    , Run Memory ["-t", "mem: <used>M (<usedratio>%)"] 20
                      -- Disk space free
                    , Run DiskU [("/", "hdd: <free> free")] [] 60
                      -- Runs custom script to check for pacman updates.
                      -- This script is in my dotfiles repo in .local/bin.
                      -- , Run Com "/home/dt/.local/bin/pacupdate" [] "pacupdate" 36000
                      -- Runs a standard shell command 'uname -r' to get kernel version
                      -- , Run Com "uname" ["-r"] "" 3600
                      -- Prints out the left side items such as workspaces, layout, etc.
                      -- The workspaces are 'clickable' in my configs.
                    , Run Battery [ "--template" , "batt: <acstatus>"
                             , "--Low"      , "10"        -- units: %
                             , "--High"     , "80"        -- units: %
                             , "--low"      , "darkred"
                             , "--normal"   , "darkorange"
                             , "--high"     , "darkgreen"

                             , "--" -- battery specific options
                                       -- discharging status
                                       , "-o"	, "<left>% (<timeleft>)"
                                       -- AC "on" status
                                       , "-O"	, "<fc=#dAA520>Charging</fc>"
                                       -- charged status
                                       , "-i"	, "<fc=#006000>Charged</fc>"
                             ]  50
                    , Run StdinReader
                    ]
       , sepChar = "%"
       , alignSep = "}{"
       , template = "%StdinReader% }{ <fc=#666666> | </fc><fc=#ffffff> %cpu% </fc><fc=#666666> |</fc><fc=#ffffff> %memory% </fc><fc=#666666> |</fc> <fc=#ffffff> %disku% </fc><fc=#666666> |</fc> <fc=#ffffff> %wlp0s20f3% </fc><fc=#666666> |</fc> <fc=#ffffff> %battery%  </fc> <fc=#666666> |</fc> <fc=#ffffff> %date%                                      </fc>"
       }
