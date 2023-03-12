package yenten

import (
	"github.com/martinboehm/btcd/wire"
	"github.com/martinboehm/btcutil/chaincfg"
	"github.com/trezor/blockbook/bchain/coins/btc"
)

// magic numbers
const (
	MainnetMagic wire.BitcoinNet = 0x9feb5aad
	TestnetMagic wire.BitcoinNet = 0x95e45495
)

// chain parameters
var (
	MainNetParams chaincfg.Params
	TestNetParams chaincfg.Params
)

func init() {
	MainNetParams = chaincfg.MainNetParams
	MainNetParams.Net = MainnetMagic
	MainNetParams.PubKeyHashAddrID = []byte{78}
	MainNetParams.ScriptHashAddrID = []byte{10}
	MainNetParams.Bech32HRPSegwit = "ytn"

	TestNetParams = chaincfg.TestNet3Params
	TestNetParams.Net = TestnetMagic
	TestNetParams.PubKeyHashAddrID = []byte{112}
	TestNetParams.ScriptHashAddrID = []byte{197}
	TestNetParams.Bech32HRPSegwit = "tytn"
}

// YentenParser handle
type YentenParser struct {
	*btc.BitcoinLikeParser
}

// NewYentenParser returns new YentenParser instance
func NewYentenParser(params *chaincfg.Params, c *btc.Configuration) *YentenParser {
	return &YentenParser{BitcoinLikeParser: btc.NewBitcoinLikeParser(params, c)}
}

// GetChainParams contains network parameters for the main Yenten network,
// and the test Yenten network
func GetChainParams(chain string) *chaincfg.Params {
	if !chaincfg.IsRegistered(&MainNetParams) {
		err := chaincfg.Register(&MainNetParams)
		if err == nil {
			err = chaincfg.Register(&TestNetParams)
		}
		if err != nil {
			panic(err)
		}
	}
	switch chain {
	case "test":
		return &TestNetParams
	default:
		return &MainNetParams
	}
}
