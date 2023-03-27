import 'package:collection/collection.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/src/api/channels/dm_channel.dart';
import 'package:mineral/src/api/channels/news_channel.dart';
import 'package:mineral/src/api/channels/stage_channel.dart';
import 'package:mineral_console/mineral_console.dart';

class PartialChannel {
  final Snowflake _id;

  PartialChannel(this._id);

  /// Get id of this
  Snowflake get id => _id;

  T cast<T>() => this as T;

  @override
  String toString () => '<#$id>';
}

enum ChannelType {
  guildText(0),
  private(1),
  guildVoice(2),
  groupDm(3),
  guildCategory(4),
  guildNews(5),
  guildNewsThread(10),
  guildPublicThread(11),
  guildPrivateThread(12),
  guildStageVoice(13),
  guildDirectory(14),
  guildForum(15);

  final int value;
  const ChannelType(this.value);
}

class ChannelWrapper {
  static dynamic create (dynamic payload) {
    if (payload['type'] == null) {
      return null;
    }

    final ChannelType? channelType = ChannelType.values.firstWhereOrNull((element) => element.value == payload['type']);

    if (channelType == null) {
      Console(theme: DefaultTheme()).warn("Guild channel ${payload['type']} don't exist! Please report this to our team.");
      return null;
    }

    switch (channelType) {
      case ChannelType.guildText:
        return TextChannel.fromPayload(payload);
      case ChannelType.guildVoice:
        return VoiceChannel.fromPayload(payload);
      case ChannelType.guildNews:
        return NewsChannel.fromPayload(payload);
      case ChannelType.guildCategory:
        return CategoryChannel.fromPayload(payload);
      case ChannelType.guildPublicThread:
        return ThreadChannel.fromPayload(payload);
      case ChannelType.private:
        return DmChannel.fromPayload(payload);
      case ChannelType.guildNewsThread:
        return ThreadChannel.fromPayload(payload);
      case ChannelType.guildPrivateThread:
        return ThreadChannel.fromPayload(payload);
      case ChannelType.guildStageVoice:
        return StageChannel.fromPayload(payload);
      case ChannelType.guildForum:
        return ForumChannel.fromPayload(payload);
      default:
        Console(theme: DefaultTheme()).warn('$channelType is not supported');
    }

    return null;
  }
}
