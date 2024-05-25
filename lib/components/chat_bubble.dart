import 'dart:async';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final String type;
  final bool isMe;
  final Timestamp time;

  const ChatBubble(
      {super.key,
      required this.message,
      required this.type,
      required this.isMe,
      required this.time});

  @override
  Widget build(BuildContext context) {
    Completer<ui.Image> completer = Completer<ui.Image>();
    if (type == "image") {
      Image image = Image.network(message);
      image.image.resolve(const ImageConfiguration()).addListener(
          ImageStreamListener((ImageInfo info, bool synchronousCall) {
        completer.complete(info.image);
      }));
    }
    return Padding(
      padding: EdgeInsets.only(
        left: isMe ? 50 : 0,
        right: isMe ? 0 : 50,
        top: 0,
        bottom: 0,
      ),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(type == "text" ? 10 : 5),
            decoration: BoxDecoration(
              color:
                  isMe ? Colors.blue : Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(15),
                  topRight: const Radius.circular(15),
                  bottomLeft: Radius.circular(isMe ? 15 : 0),
                  bottomRight: Radius.circular(isMe ? 0 : 15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                type == "text"
                    ? Text(
                        message,
                        style: TextStyle(
                          color: isMe
                              ? Colors.white
                              : Theme.of(context).textTheme.displayLarge!.color,
                        ),
                      )
                    : GestureDetector(
                        onTap: () async {
                          final imageProvider = Image.network(message).image;
                          showImageViewer(
                            context,
                            imageProvider,
                            onViewerDismissed: () {},
                            swipeDismissible: true,
                            doubleTapZoomable: true,
                          );
                        },
                        child: FutureBuilder<ui.Image>(
                          future: completer.future,
                          builder: (BuildContext context,
                              AsyncSnapshot<ui.Image> snapshot) {
                            if (snapshot.hasData) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  message,
                                  width: snapshot.data!.width.toDouble() >
                                          snapshot.data!.height.toDouble()
                                      ? 300
                                      : 200,
                                  height: snapshot.data!.width.toDouble() >
                                          snapshot.data!.height.toDouble()
                                      ? 200
                                      : 300,
                                  fit: BoxFit.cover,
                                ),
                              );
                            } else {
                              return const CircularProgressIndicator();
                            }
                          },
                        ),
                      ),
                const SizedBox(height: 5),
                Text(
                  time.toDate().toString().substring(11, 16),
                  style: TextStyle(
                    color: isMe
                        ? Colors.white
                        : Theme.of(context).textTheme.displayLarge!.color,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
