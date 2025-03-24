import 'package:flutter/material.dart';
import '../models/crypto_currency.dart';

class CryptoSelectionWidget extends StatelessWidget {
  final List<CryptoCurrency> selectedCryptos;
  final Function(CryptoCurrency) onCryptoSelected;
  final Function(CryptoCurrency) onCryptoRemoved;

  const CryptoSelectionWidget({
    super.key,
    required this.selectedCryptos,
    required this.onCryptoSelected,
    required this.onCryptoRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSelectedCryptos(),
        const SizedBox(height: 16),
        _buildAvailableCryptos(),
      ],
    );
  }

  Widget _buildSelectedCryptos() {
    if (selectedCryptos.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            'Select up to 3 cryptocurrencies',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: selectedCryptos.map((crypto) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFF3BA2F).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFF3BA2F),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(crypto.iconUrl),
              ),
              const SizedBox(width: 8),
              Text(
                crypto.symbol,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF3BA2F),
                ),
              ),
              const SizedBox(width: 4),
              InkWell(
                onTap: () => onCryptoRemoved(crypto),
                child: const Icon(
                  Icons.close,
                  size: 16,
                  color: Color(0xFFF3BA2F),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAvailableCryptos() {
    final availableCryptos = supportedCryptos
        .where((crypto) => !selectedCryptos.contains(crypto))
        .toList();

    if (availableCryptos.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            'Maximum cryptocurrencies selected',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: availableCryptos.length,
      itemBuilder: (context, index) {
        final crypto = availableCryptos[index];
        return InkWell(
          onTap: selectedCryptos.length < 3
              ? () => onCryptoSelected(crypto)
              : null,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: selectedCryptos.length < 3
                  ? Colors.grey.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.transparent,
                  backgroundImage: NetworkImage(crypto.iconUrl),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        crypto.symbol,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        crypto.name,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (selectedCryptos.length < 3)
                  const Icon(
                    Icons.add_circle_outline,
                    size: 20,
                    color: Color(0xFFF3BA2F),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}