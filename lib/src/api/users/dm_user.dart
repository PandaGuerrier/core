import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral_ioc/ioc.dart';

class DmUser extends User {
  final Snowflake _channelId;

  DmUser(
    super._id,
    super._username,
    super._discriminator,
    super._bot,
    super._system,
    super._publicFlags,
    super._flags,
    super._decoration,
    super.premiumType,
    super._lang,
    this._channelId
  );

  Future<void> remove () async {
    await ioc.use<DiscordApiHttpService>()
      .destroy(url: '/channels/$_channelId/recipients/$id')
      .build();
  }

  factory DmUser.fromUser (User user, Snowflake channelId) {
    return DmUser(
      user.id,
      user.username,
      user.discriminator,
      user.isBot,
      user.isSystem,
      user.publicFlags,
      user.flags,
      user.decoration,
      user.lang.locale,
      user.premiumType,
      channelId,
    );
  }
}