import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/managers/message_manager.dart';

import 'package:mineral/src/api/managers/permission_overwrite_manager.dart';
import 'package:mineral/src/api/managers/thread_manager.dart';
import 'package:mineral/src/api/managers/webhook_manager.dart';

class TextChannel extends TextBasedChannel {
  TextChannel(
    super.id,
    super._type,
    super._position,
    super._label,
    super._applicationId,
    super._flags,
    super._webhooks,
    super.permissionOverwrites,
    super._guild,
    super.description,
    super.nsfw,
    super.lastMessageId,
    super.lastPinTimestamp,
    super._messages,
    super._threads,
  );

  @override
  Future<TextChannel> setDescription (String description) async {
    return await super.setDescription(description);
  }

  @override
  Future<TextChannel> setNsfw (bool value) async {
    return await super.setNsfw(value);
  }

  @override
  Future<TextChannel?> update ({ String? label, String? description, int? delay, int? position, CategoryChannel? categoryChannel, bool? nsfw, List<PermissionOverwrite>? permissionOverwrites }) async {
    return await super.update(label: label, description: description, delay: delay, position: position, categoryChannel: categoryChannel, nsfw: nsfw, permissionOverwrites: permissionOverwrites);
  }

  factory TextChannel.from(dynamic payload) {
    MineralClient client = ioc.singleton(ioc.services.client);
    Guild? guild = client.guilds.cache.get(payload['guild_id']);

    final PermissionOverwriteManager permissionOverwriteManager = PermissionOverwriteManager();
    for(dynamic element in payload['permission_overwrites']) {
      final PermissionOverwrite overwrite = PermissionOverwrite.from(payload: element);
      permissionOverwriteManager.cache.putIfAbsent(overwrite.id, () => overwrite);
    }

    TextChannel channel =  TextChannel(
      payload['id'],
      ChannelType.guildText,
      payload['position'],
      payload['name'],
      payload['application_id'],
      payload['flags'],
      WebhookManager(guildId: guild?.id),
      permissionOverwriteManager,
      guild,
      payload['topic'],
      payload['nsfw'] ?? false,
      payload['last_message_id'],
      payload['last_pin_timestamp'] != null ? DateTime.parse(payload['last_pin_timestamp']) : null,
      MessageManager(),
      ThreadManager(guildId: guild?.id),
    );

    channel.threads.channel = channel;

    return channel;
  }
}
