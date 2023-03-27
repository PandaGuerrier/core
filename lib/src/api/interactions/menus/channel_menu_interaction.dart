import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/interactions/menus/select_menu_interaction.dart';
import 'package:mineral_ioc/ioc.dart';

class ChannelMenuInteraction extends SelectMenuInteraction {
  final MenuBucket _menu;

  ChannelMenuInteraction(
    super.id,
    super.label,
    super.applicationId,
    super.version,
    super.type,
    super.token,
    super.user,
    super.guild,
    super.messageId,
    super.customId,
    super.channelId,
    this._menu,
  );

  MenuBucket get menu => _menu;

  factory ChannelMenuInteraction.from(dynamic payload) => ChannelMenuInteraction(
    payload['id'],
    null,
    payload['application_id'],
    payload['version'],
    payload['type'],
    payload['token'],
    payload['member']?['user']?['id'],
    payload['guild_id'],
    payload['message']?['id'],
    payload['data']['custom_id'],
    payload['channel_id'],
    MenuBucket(payload['guild_id'], List<Snowflake>.from(payload['data']['values'])),
  );
}

class MenuBucket {
  final Snowflake? _guildId;
  final List<Snowflake> _data;

  MenuBucket(this._guildId, this._data);

  Guild? get _guild => ioc.use<MineralClient>().guilds.cache.getOrFail(_guildId);

  /// ### Return an [List] of [PartialChannel] if this has the designed field
  ///
  /// Example :
  /// ```dart
  /// List<PartialChannel> channels = event.interaction.menu.getChannels();
  /// ```
  List getChannels<PartialChannel> () => _data
    .map((id) => _guildId != null
      ? _guild!.channels.cache.getOrFail(id)
      : ioc.use<MineralClient>().dmChannels.cache.getOrFail(id))
    .toList();


  /// ### Return the first [T] if this has the designed field
  ///
  /// Example :
  /// ```dart
  /// final channel = event.interaction.menu.getChannel<TextChannel>();
  /// ```
  T? getChannel<T extends PartialChannel> ({ int index = 0 }) => _guildId != null
    ? _guild!.channels.cache.get(_data[index])
    : ioc.use<MineralClient>().dmChannels.cache.get(_data[index]);
}
