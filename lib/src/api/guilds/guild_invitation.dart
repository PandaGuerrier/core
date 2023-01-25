import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';
import 'package:mineral_ioc/ioc.dart';

class GuildInvitation {
  final String _code;
  final Snowflake _guildId;
  final Snowflake? _channelId;
  final String _expiresAt;
  final Snowflake _type;

  GuildInvitation(this._code, this._guildId, this._channelId, this._expiresAt, this._type);

  String get code => _code;
  Guild get guild => ioc.use<MineralClient>().guilds.cache.getOrFail(_guildId);
  GuildChannel? get channel => guild.channels.cache.get(_channelId);
  DateTime get expiresAt => DateTime.parse(_expiresAt);
  Snowflake get type => _type;
}
