# Cryptool
A local ruby on rails server to host a cryptography tool for use

## ⚡ What is this repository?
A self-hosted cryptography tool to encrypt and decrypt files or text based with more than 7 different encryption algorithms

## 🔥 Features
- Encrypt and decrypt text or file with your own key and multiple encryption algorithms

## 🖥️ Running locally for development

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

4. Create database
```sh
rails db:create
```

5. Run migrations
```sh
rails db:migrate
```

6. Run the server
```sh
rails server
```

7. Open the tool in this url
```sh
http://localhost:3000/cryptool/tool
```

## ⚠️ Dependencies 
## 📖 How to add field to a model
1. Generate a new migration file 
```sh
rails generate migration <migration_name> <field>:<data_type>
```
2. Edit the migration file
3. Run db migrations
```sh
rails db:migrate
```
## 🫂 Contributors
- Juan Christopher Santoso (13521116)
- Nicholas Liem (13521135)