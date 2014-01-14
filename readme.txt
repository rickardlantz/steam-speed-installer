Read me!

Steam Speed Installer is a simple application that allows the user to save copies of their steam game files for a later installation.

The copied game can be installed on the same computer or on another computer; this allows many users to install the same game without having to download it several times.

Your currently installed games will be listed in the “Local Games” list, click “Store Local Game” to save it. (The game will be saved to the folder “\SSI_Data\Games” in the same directory as this file.

Your stored games will be listed in the “Stored Games” list, click “Install Stored Game” to install it. You will still have to install the game via Steam. However, steam should detect that all files are present, and skip downloading.

Note that for some games, values such as "name" may be missing in the lists. This is because the application first collects a list of items from the steam config file, and then tries to math the game-ID with the respective appmanifest-file. The "error" occurs because the appmanifest file is not present for all games.