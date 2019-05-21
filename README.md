#  Space Encoders

The goal of the project is to create an educational game to learn the mechanics of computer science to novices.
Here you will find a computerized version of the created game.

## Getting Started

The following instructions will get you a copy of the project.

### Prerequisites

You need to install these things below to be able to run the project on your local system.

* macOS High Sierra Version 10.13.6 or later
* Xcode Version 10.1 or later (Terminal Xcode)
* Swift Version 4.2.1  (Terminal)

### Installing

The first step you have to do is to installing the project in your system.

* Clone the repository

```
git clone https://github.com/cui-unige/BSc-educative-gaming-2019.git
```

* Switch on the branch devInf

```
git checkout devInf
```

* Enter in the folder of the game

```
cd SeriousGame/
```

To install on Ubuntu you have to upgrade your swift version to 4.2.1

For Ubuntu 16.04 follow the next steps

```
sudo apt-get install clang

sudo apt-get install libcurl3 libpython2.7 libpython2.7-dev 

wget https://swift.org/builds/swift-4.2.1-release/ubuntu1604/swift-4.2.1-RELEASE/swift-4.2.1-RELEASE-ubuntu16.04.tar.gz

mkdir ~/swift

tar -xvzf swift-4.2.1-RELEASE-ubuntu16.04.tar.gz -C ~/swift

sudo nano ~/.bashrc

export PATH=~/swift/swift-4.2.1-RELEASE-ubuntu16.04/usr/bin:$PATH
```
Then verify the new version is correctly install

```
swift –-version
```

If you are on Ubuntu 18.04 or later, simply replace every *16.04* by *18.04*


You have now access of every files of the implementation. 


### Run the game in your terminal

You can run the game with this following command 

```
swift build
swift run
```

### Run the game with Xcode

You can also run the game with xcode using the integrated console

You have to be in the folder which contains the Xcode project file *SeriousGame.xcodeproj*

To do this follow the *Installing* part

Then open the Xcode project with the command below

```
open -a Xcode SeriousGame.xcodeproj/
```


## Space Encoders is built with

* [Xcode](https://developer.apple.com/xcode/) - The code editor used
* [Swift](https://developer.apple.com/swift/) - The language used


## Authors

You can find here the list of contributors who participated in this project just below

* Patrick SARDINHA
* Marvin FOURASTIE

## License

This project don't have any license yet.

