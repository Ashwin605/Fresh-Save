import 'package:flutter/material.dart';

/// Floating WhatsApp button matching reference (bottom-right corner).
class FloatingWhatsAppButton extends StatelessWidget {
  const FloatingWhatsAppButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 14,
      bottom: 20, // Sits comfortably just above bottom nav
      child: Material(
        elevation: 6,
        shape: const CircleBorder(),
        shadowColor: Colors.black.withValues(alpha: 0.25),
        child: InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Connecting to FreshSave WhatsApp support...'),
                duration: Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          customBorder: const CircleBorder(),
          child: Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF25D366),
            ),
            child: const Center(
              child: Icon(
                Icons.chat_bubble,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
