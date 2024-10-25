NETWORK=mainnet-beta
KEYPAIR_TOKEN_AUTHORITY=./.keypairs/${NETWORK}/dvLncd1nbCNCBqunQN1iK34vcMu9MP233MSTMqgeKVC.json


TOKEN_MINT=BBTX8ZaLTEdjLTi8u2E2iG2enoBJBsijNuVzLaYrH1m3
ZERO_TOKEN_MINT=zerodMiAeCJhUdQZ8A4pbRYfqu81enR39h6JjeDtJVd

KEYPAIR_TOKEN_MINT=./.keypairs/${NETWORK}/${TOKEN_MINT}.json
KEYPAIR_ZERO_TOKEN_MINT=./.keypairs/${NETWORK}/${ZERO_TOKEN_MINT}.json

env:
	solana config set --url ${NETWORK}
	solana config set --keypair ${KEYPAIR_TOKEN_AUTHORITY}
	cp ${KEYPAIR_TOKEN_AUTHORITY} ~/.config/solana/id.json

create-zero:
	spl-token create-token --decimals 9 ${KEYPAIR_ZERO_TOKEN_MINT} || true
	spl-token create-account ${ZERO_TOKEN_MINT} || true
	spl-token mint ${ZERO_TOKEN_MINT} 1000000000

metadata-create-zero:
	metaboss create metadata --metadata ./zero-token.json --mint ${ZERO_TOKEN_MINT}

metadata-update-zero:
	metaboss update uri --account ${ZERO_TOKEN_MINT} --new-uri=https://raw.githubusercontent.com/Mybasebet/BBT/main/zero-metadata.json

disable-auth-zero:
	spl-token authorize ${ZERO_TOKEN_MINT} mint --disable
	spl-token authorize ${ZERO_TOKEN_MINT} freeze --disable

airdrop:
	solana --url ${NETWORK} \
	--keypair ${KEYPAIR_AUTH} \
	airdrop 1

