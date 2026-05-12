import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:it/constants.dart';
import 'package:it/main.dart';
import 'package:it/widgets/player_icon.dart';

class TagSheet extends StatefulWidget {
  final Player taggedPlayer;
  const TagSheet({super.key, required this.taggedPlayer});

  @override
  State<TagSheet> createState() => _TagSheetState();
}

class _TagSheetState extends State<TagSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        border: BoxBorder.fromLTRB(
          top: BorderSide(color: styling.blue, width: 4),
          left: BorderSide(color: styling.blue, width: 4),
          right: BorderSide(color: styling.blue, width: 4),
        ),
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 32),
          PlayerIcon(player: widget.taggedPlayer, size: 100, iconSize: 50),
          const SizedBox(height: 16),
          Text(
            "Did you tag ${widget.taggedPlayer.name}?",
            style: styling.headerFont.copyWith(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: styling.blue,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  router.pop();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: styling.lightPink,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: styling.blue, width: 2),
                  ),
                  child: Text(
                    "No",
                    style: styling.bodyFont.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: styling.blue,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  gameNotifier.value!.tagPlayer(widget.taggedPlayer.id);

                  gameNotifier.refresh();

                  router.pushReplacement('/gotcha');
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: styling.pink,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: styling.pink, width: 2),
                  ),
                  child: Text(
                    "Yes",
                    style: styling.bodyFont.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
