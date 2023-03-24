import 'package:mineral/core/builders.dart';
import 'package:mineral/src/api/builders/buttons/contracts/link_contract.dart';

class LinkButton extends ButtonBuilder implements LinkContract {
  LinkButton(super.customId, super.url, super.style);
}