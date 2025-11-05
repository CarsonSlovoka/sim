# Set Input Method

在mac上可以用指令來切換輸入法

使得有辦法讓nvim離開insert後, 可以自動切換到英文輸入法


## Build & Install

```sh
git clone https://github.com/CarsonSlovoka/sim.git
cd sim
swiftc -o sim sim.swift
./sim -v
sudo mv -v sim /usr/local/bin/
sim -v
```


## Usage

```sh
sim # list all switchable input methods
sim com.apple.keylayout.ABC
sim com.boshiamy.inputmethod.BoshiamyIMK
```
