# 💳 Wallet-Bivix

In this project, a virtual wallet will be developed.

## 🚀 Technologies Used

- **Ruby**
- **Sinatra** (as the web framework)
- **JavaScript**
- **HTML5**
- **CSS3**
- **SQLite** for the database
- **Bundle** for managing Ruby dependencies
- **Docker**
- **BCrypt**
- **Pony**
- **Spec**

## 📌 Features

✅ User registration and login

✅ Account creation

✅ Card and transaction management

:white_check_mark: QR Payments

:white_check_mark: Savings

:white_check_mark: Contact book for transfers

:white_check_mark: QR Charges

:white_check_mark: And more...

## Requirements for run this app

Make sure that you have docker instaled in your PC and docker compose plugin

###### Linux/Mac
```bash
docker -v
docker compose version
```

###### Windows
```bash
docker version
docker compose version
```



If you don't have docker installed yet check the [Docker Installation Guide](https://docs.docker.com/engine/)

## Running the app

- Clone this repository

- Change the example.env file with your configuration

- In views/charge-link.erb change the response
```javascript
const response = await fetch('https://api.tinyurl.com/create', {
        method: 'POST',
        headers: {
          'Authorization': 'Bearer API_KEY_HERE', //put ypur api key instead of API_KEY_HERE
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ url: longUrl })
      }
```

- Open a terminal and go to the directory where you cloned this repository, then run 
```bash
docker compose up --build 
```

- In your favorite browser search [http://localhost:8000](http://localhost:8000)

- Enjoy our wallet :smile:
