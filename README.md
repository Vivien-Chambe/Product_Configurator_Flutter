# Product_Configurator_Flutter
A demo app to learn Flutter usage 

### USe the application : 
For Windows : 
Download the Release Windows folder, the you can find the exe and use it 


### Edit the products list :

You can edit the products.json file. 
For Windows Release it can be found in the `data/flutter_assets/assets/` folder.
For android relaeases
The json file is organised like this:

```json
[
{
        "title": "Product 1",
        "imagePath": "assets/images/pc-asset.jpg",
        "link": "https://github.com/neiviv-dev",
        "screens": [
            {
              "name": "Screen 1",
              "number": 1,
              "price": 10.0
            },
            {
              "name": "Screen 2",
              "number": 2,
              "price": 20.0
            },
            {
              "name": "Screen 3",
              "number": 3,
              "price": 30.0
            }
          ],
        "categories": [
          {
            "name": "CPU / Processor",
            "description": "One CPU",
            "options": [
              {
                  "name": "Intel Core i3",
                  "price": 142.0
              },
              {
                  "name": "Intel Core i5",
                  "price": 196.0
                },
              {
                  "name": "Intel Core i7-12700 2.10G 25MB 12 cores 65W",
                  "price": 325.00
              }
            ]
          },
          {
            "name": "Operating System",
            "description": "Please take cores of CPU into account",
            "options": [
              {
                  "name": "None",
                  "price": 0.0
              },
              {
                  "name": "Windows 10 Pro 64-bit",
                  "price": 50.60
              },
              {
                  "name": "Windows 11 Pro 64-bit",
                  "price": 101.20
              }
              ]
          },
          {
            "name": "Memory",
          "description": "Please take cores of CPU into account",
            "options": [
              {
                  "name": "None",
                  "price": 0.0
              },
              {
                  "name": "8GB (1x8GB) DDR5 4800 ",
                  "price": 50.60
              },
              {
                  "name": "16GB (2x8GB) DDR5 4800 ",
                  "price": 101.20
              }
              ]
          },
          {
            "name": "Storage",
            "description": "3 slots available:\nup to 2x internal M.2 Storage,\n1x internal Storage with 2,5 in",
            "options": [
              {
                  "name": "None",
                  "price": 0.0
              },
              {
                  "name": "256GB M.2 2280 NVMe SSD",
                  "price": 50.60
              },
              {
                  "name": "512GB M.2 2280 NVMe SSD",
                  "price": 101.20
              }
              ]
          },
          {
            "name": "Interfaces",
            "description": "",
            "options": [
              {
                  "name": " 4xUSB -A 10 Gbit/s / 2x DP / 1x USB -C / Audio/ RJ-45",
                  "price": 0.0
              }
              ]
          },
          {
            "name": "Graphics",
            "description": "1 slots available onboard graphic card\nONLY available with iCore CPU ",
            "options": [
              {
                  "name": "None",
                  "price": 0.0
              },
              {
                  "name": "Intel UHD Graphics 750",
                  "price": 50.60
              },
              {
                  "name": "NVIDIA GeForce RTX 3060 12GB GDDR6",
                  "price": 101.20
              }
              ]
          },
          {
            "name": "Keyboards",
            "description": "",
            "options": [
              {
                  "name": "Keyboard GR (incl. in base unit)",
                  "price": 0.0
              },
              {
                  "name": "No Keyboard",
                  "price": -6.35
              },
                {
                    "name": "RGB Keyboard",
                    "price": 11.37
                },
                {
                    "name": "Wired Keyboard",
                    "price": -0.69
                }
                ]
              
          }
              ]
          }
 ]


``` 



