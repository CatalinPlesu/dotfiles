#!/bin/sh
if grep Dark ~/.config/VSCodium/User/settings.json
then
	sed -i 's/Dark/Light/g' ~/.config/VSCodium/User/settings.json
else

	sed -i 's/Light/Dark/g' ~/.config/VSCodium/User/settings.json 
fi
