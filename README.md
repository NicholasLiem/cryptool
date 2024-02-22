# Cryptool
A local ruby on rails server to host a cryptography tool for use

## ⚡ What is this repository?
A self-hosted cryptography tool to encrypt and decrypt files or text based with more than 7 different encryption algorithms

## 🔥 Features
- Encrypt and decrypt text or file with your own key and multiple encryption algorithms
- Provided with enough spec files to check how the program works! (spec folder)

## 🖥️ Running locally for development
Please make sure you have Ruby version `3.2.2` installed. You can change the Ruby version based on your local Ruby in the `.ruby-version` file in the root directory.

1. Clone this repository
```sh
git@github.com:NicholasLiem/cryptool.git
```

2. Change the current directory to 'cryptool' folder
```sh
cd cryptool
```

3. Install gem dependencies
```sh
bundle install
```

4. Run the server
```sh
rails server
```

7. Open the tool in this url
```sh
http://localhost:3000/
```

## ⚠️ Dependencies 
* Mime-types for file handling
