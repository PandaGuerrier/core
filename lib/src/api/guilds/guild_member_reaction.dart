import 'package:http/http.dart';
import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/src/api/emoji.dart';
import 'package:mineral/src/api/managers/guild_member_reaction_manager.dart';
import 'package:mineral/src/api/messages/partial_message.dart';
import 'package:mineral_ioc/ioc.dart';

class GuildMemberReaction  {
  final GuildMemberReactionManager _manager;
  final PartialEmoji _partialEmoji;
  final PartialMessage _message;
  final User user;

  GuildMemberReaction(this._manager, this._partialEmoji, this._message, this.user);

  Future<void> remove () async {
    String _emoji = _partialEmoji is Emoji
      ? '${_partialEmoji.label}:${_partialEmoji.id}'
      : _partialEmoji.label;

    Response response = await ioc.use<DiscordApiHttpService>()
      .destroy(url: '/channels/${_message.channel.id}/messages/${_message.id}/reactions/$_emoji/${user.id}')
      .build();

    if (response.statusCode == 200) {
      _manager.reactions.remove(_emoji);
    }
  }
}
