#### Install cups

``` 
sudo apt install -y cups 
```

``` 
# This is to add the current user pi as admin
sudo usermod -a -G lpadmin pi 
```

#### Configure cups
access ip:631 to add printers

If the printer driver is not automatically detected, use Make: Generic --> Generic IPP Everywhere as driver

#### Create below folder stucture

├── polling </br>
├── polling.sh </br>

* Polling folder: All the files within the polling folder will be sent to the priter to print
* Polling.sh: The script to run on the background, to check if there any file in the polling folder, if so, it sends the files to the printer every 5 seconds.

#### Polling.sh content

```
#!/bin/bash

# Directory to be processed
DIRECTORY="./polling"

while [ 1 ]; do

# Check each file in the directory
for FILE in "$DIRECTORY"/*
do
    # Check if file size is greater than 5 bytes
    if [ -f "$FILE" ] && [ $(stat -c%s "$FILE") -gt 5 ]; then
        lp -d printer_name $FILE
    fi
done

# Delete all files in the directory
rm -f "$DIRECTORY"/*

sleep 5

done

```


