import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/src/api/guilds/guild_invitation.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';
import 'package:mineral_ioc/ioc.dart';

class GuildInvitesManager extends CacheManager<GuildInvitation>  {
  final Snowflake _guildId;
  GuildInvitesManager(this._guildId);

  Future<void> fetch () async {
    final response = await ioc.use<DiscordApiHttpService>()
      .get(url: '/guilds/$_guildId/invites')
      .build();

    print(response.body);
  }
}
