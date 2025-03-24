class CryptoCurrency {
  final String symbol;
  final String name;
  final String iconUrl;
  double currentPrice;
  double priceChangePercent24h;

  CryptoCurrency({
    required this.symbol,
    required this.name,
    required this.iconUrl,
    this.currentPrice = 0.0,
    this.priceChangePercent24h = 0.0,
  });

  factory CryptoCurrency.fromJson(Map<String, dynamic> json) {
    return CryptoCurrency(
      symbol: json['symbol'],
      name: json['name'],
      iconUrl: json['image'] ?? '',
      currentPrice: (json['current_price'] ?? 0.0).toDouble(),
      priceChangePercent24h: (json['price_change_percentage_24h'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'name': name,
      'image': iconUrl,
      'current_price': currentPrice,
      'price_change_percentage_24h': priceChangePercent24h,
    };
  }
}

// Predefined list of supported cryptocurrencies
final List<CryptoCurrency> supportedCryptos = [
  CryptoCurrency(
    symbol: 'BTC',
    name: 'Bitcoin',
    iconUrl: 'https://assets.coingecko.com/coins/images/1/large/bitcoin.png',
  ),
  CryptoCurrency(
    symbol: 'ETH',
    name: 'Ethereum',
    iconUrl: 'https://assets.coingecko.com/coins/images/279/large/ethereum.png',
  ),
  CryptoCurrency(
    symbol: 'BNB',
    name: 'Binance Coin',
    iconUrl: 'https://assets.coingecko.com/coins/images/825/large/bnb-icon2_2x.png',
  ),
  CryptoCurrency(
    symbol: 'SOL',
    name: 'Solana',
    iconUrl: 'https://assets.coingecko.com/coins/images/4128/large/solana.png',
  ),
];