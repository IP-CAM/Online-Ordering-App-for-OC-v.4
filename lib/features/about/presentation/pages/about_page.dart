import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordering_app/core/utils/loader.dart';
import 'package:ordering_app/features/about/presentation/blocs/info/info_bloc.dart';
import 'package:ordering_app/features/about/presentation/widgets/about_card.dart';
import 'package:ordering_app/features/about/presentation/widgets/contact_card.dart';
import 'package:ordering_app/features/about/presentation/widgets/delivery_info_card.dart';
import 'package:ordering_app/features/about/presentation/widgets/opening_times_card.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<InfoBloc>(context).add(FetchInfoEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: BlocConsumer<InfoBloc, InfoState>(
                  listener: (context, state) {
            if (state is InfoLoading) {
              Loader.show(context);
            } else {
              Loader.hide();
            }
                  },
                  builder: (context, state) {
            if (state is InfoSuccess) {
              final info = state.info;
              return Column(
                children: [
                  ContactCard(contact: info.contact),
                  OpeningTimesCard(openingTimes: info.openingTimes),
                  DeliveryInfoCard(deliveryInfo: info.deliveryInfo),
                  AboutCard(about: info.about),
                ],
              );
            }
            return const Center(
              child: Text('No information found!'),
            );
                  },
                ),
          ),
        ));
  }
}
