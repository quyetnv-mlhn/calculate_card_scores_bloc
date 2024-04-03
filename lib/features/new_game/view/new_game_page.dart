import 'package:calculate_card_score/core/constants/app_const.dart';
import 'package:calculate_card_score/core/constants/app_style.dart';
import 'package:calculate_card_score/features/new_game/bloc/new_game_bloc.dart';
import 'package:calculate_card_score/features/new_game/widgets/ordinal_number.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NewGamePage extends StatelessWidget {
  const NewGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewGameBloc(),
      child: const NewGameView(),
    );
  }
}

class NewGameView extends StatefulWidget {
  const NewGameView({super.key});

  @override
  State<NewGameView> createState() => _NewGameViewState();
}

class _NewGameViewState extends State<NewGameView> {
  late TextEditingController valueGameRuleController;
  GameRule gameRuleSelected = GameRule.normal;

  @override
  void initState() {
    super.initState();
    valueGameRuleController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    valueGameRuleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quantityPlayer = [2, 3, 4, 5];

    return Scaffold(
      backgroundColor: primaryLightColor,
      appBar: AppBar(
        title: Text(
          'New game',
          style: AppStyle.boldTextStyle(color: primaryLightColor, size: 20.0),
        ),
        backgroundColor: primaryColor,
        automaticallyImplyLeading: true,
      ),
      body: BlocBuilder<NewGameBloc, NewGameState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: smallPadding,
              horizontal: largePadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildChooseQuantityPlayer(context, state, quantityPlayer),
                _buildGridView(state),
                _buildGameRule(context, state),
              ],
            ),
          );
        },
      ),
    );
  }

  GridView _buildGridView(NewGameState state) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: largePadding,
        mainAxisSpacing: smallPadding,
      ),
      itemCount: state.playerQuantity,
      itemBuilder: (BuildContext ctx, index) {
        return _buildInfoPlayer(index);
      },
    );
  }

  Widget _buildChooseQuantityPlayer(
    BuildContext context,
    NewGameState state,
    List<int> quantityPlayer,
  ) {
    return Row(
      children: [
        const OrdinalNumber(number: 1),
        const SizedBox(width: smallPadding),
        Expanded(
          child: Text(
            'Select number of players',
            style: AppStyle.boldTextStyle(),
            maxLines: 1,
          ),
        ),
        const SizedBox(width: largePadding),
        SizedBox(
          width: 100,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: state.playerQuantity,
              items: quantityPlayer
                  .map((value) => DropdownMenuItem(
                        value: value,
                        child: Text(
                          '$value players',
                          style: AppStyle.mediumTextStyle(),
                        ),
                      ))
                  .toList(),
              onChanged: (int? value) {
                if (value != null) {
                  context.read<NewGameBloc>().add(NewGameChangeQuantityPlayer(value));
                }
              },
              isExpanded: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoPlayer(int index) {
    return SizedBox(
      height: 100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/images/camera-add.svg',
            width: 50,
            height: 50,
          ),
          TextField(
            style: AppStyle.mediumTextStyle(),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: 'Player ${index + 1}',
              hintStyle: AppStyle.mediumTextStyle(color: textColor),
              alignLabelWithHint: true,
              contentPadding: const EdgeInsets.symmetric(
                vertical: smallPadding,
                horizontal: largePadding,
              ),
              border: const UnderlineInputBorder(),
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameRule(BuildContext context, NewGameState state) {
    final gameRule = state.gameRule;
    final gameRuleValue = state.gameRuleValue;
    return Row(
      children: [
        const OrdinalNumber(number: 2),
        const SizedBox(width: smallPadding),
        Text(
          'Game rule',
          style: AppStyle.boldTextStyle(),
        ),
        const Spacer(),
        const SizedBox(width: largePadding),
        InkWell(
          onTap: () => _onChooseGameRule(context),
          child: Row(
            children: [
              Text(
                '${getTypeOfGameRule(gameRule)} ${gameRuleValue != '' ? ': $gameRuleValue ${getUnit(gameRule)}' : ''}',
                style: AppStyle.mediumTextStyle(),
              ),
              const SizedBox(width: smallPadding),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        )
      ],
    );
  }

  _onChooseGameRule(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return _buildDialogSelectGameRule(context);
      },
    );
  }

  BlocProvider<NewGameBloc> _buildDialogSelectGameRule(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<NewGameBloc>(context),
      child: BlocBuilder<NewGameBloc, NewGameState>(
        builder: (context, state) {
          return AlertDialog(
            scrollable: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
            title: const Text(
              'Select game rule',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            titlePadding: const EdgeInsets.only(top: largePadding),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.95,
              child: StatefulBuilder(builder: (context, setState) {
                return Column(
                  children: [
                    _buildAllOptionGameRule(context, setState),
                    _buildAllActionButton(context),
                  ],
                );
              }),
            ),
            contentPadding: const EdgeInsets.all(smallPadding),
          );
        },
      ),
    );
  }

  String getUnit(GameRule gameRule) {
    switch (gameRule) {
      case GameRule.limitGame:
        return 'games';
      case GameRule.limitScore:
        return 'points';
      case GameRule.normal:
        return '';
    }
  }

  String getTypeOfGameRule(GameRule gameRule) {
    switch (gameRule) {
      case GameRule.limitGame:
        return 'Max matches';
      case GameRule.limitScore:
        return 'Max score';
      default:
        return GameRule.normal.title;
    }
  }

  Row _buildAllActionButton(BuildContext context) {
    return Row(
      children: [
        _buildActionButton(
          text: 'Save',
          onPressed: () {
            context.read<NewGameBloc>().add(NewGameSelectGameRule(gameRuleSelected));
            if ((gameRuleSelected != GameRule.normal) && valueGameRuleController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter a value')),
              );
              return;
            }
            context.read<NewGameBloc>().add(NewGameUpdateRuleValue(valueGameRuleController.text));
            Navigator.pop(context);
          },
        ),
        const SizedBox(width: smallPadding),
        _buildActionButton(
          text: 'Cancel',
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }

  Row _buildAllOptionGameRule(
    BuildContext context,
    void Function(void Function()) setState,
  ) {
    return Row(
      children: [
        Flexible(
          flex: 2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildOptionGameRule(context, GameRule.normal, setState),
              _buildOptionGameRule(context, GameRule.limitGame, setState),
              _buildOptionGameRule(context, GameRule.limitScore, setState),
            ],
          ),
        ),
        const SizedBox(width: smallPadding),
        if (gameRuleSelected != GameRule.normal)
          Flexible(
            flex: 1,
            child: Column(
              children: [
                TextField(
                  keyboardType: const TextInputType.numberWithOptions(
                    signed: false,
                    decimal: false,
                  ),
                  controller: valueGameRuleController,
                  autofocus: true,
                  textAlign: TextAlign.center,
                  style: AppStyle.mediumTextStyle(size: 30),
                ),
                Text(getUnit(gameRuleSelected), style: AppStyle.boldTextStyle()),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildActionButton({
    required String text,
    Color color = otherColor,
    void Function()? onPressed,
  }) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(backgroundColor: color, elevation: 10),
        child: Text(text, style: AppStyle.mediumTextStyle()),
      ),
    );
  }

  ListTile _buildOptionGameRule(
    BuildContext context,
    GameRule gameRule,
    void Function(void Function()) setState,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      dense: true,
      horizontalTitleGap: smallPadding,
      title: Text(
        gameRule.title,
        style: AppStyle.mediumTextStyle(),
      ),
      leading: Radio<GameRule>(
        value: gameRule,
        groupValue: gameRuleSelected,
        onChanged: (GameRule? value) {
          valueGameRuleController.clear();
          setState(() {
            gameRuleSelected = value ?? GameRule.normal;
          });
        },
        visualDensity: const VisualDensity(
          horizontal: VisualDensity.minimumDensity,
          vertical: VisualDensity.minimumDensity,
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}