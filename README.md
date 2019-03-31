# Tang Docker Container on Alpine

## Authors

- [Michel Belleau](https://github.com/malaiwah)

## Usage
* mkdir $(pwd)/persistent
* docker run -d -p 8080:80 -v $(pwd)/persistent:/var/db/tang malaiwah/tang
* echo "Hello World..." | clevis encrypt tang '{ "url": "http://localhost:8080"}' > secret.jwe
* clevis decrypt < secret.jwe

## Original idea
- [Adrian Lucrèce Céleste](https://github.com/AdrianKoshka)

## [License](LICENSE)

[GPLv3](LICENSE)
