1. Updates and xrdp 
    ```
    sudo apt update && apt install xrdp -y
    ```

2. Connect to the bluetooth device in rdp desktop

3. Check if the device is connected with command -
    ```
    bluetoothctl info | grep 'Device\|Connected: yes'
    ```
4. Download code from https://github.com/HeuristicPerson/bluetooth_2_hid
   - Included here for reference purpose
  
5. Run script
   ```
   sudo install.sh
   ```
6. Reboot, the keyboard should be connected automatically



