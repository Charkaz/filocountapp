import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../bloc/project_bloc.dart';
import '../widgets/project_card.dart';
import '../widgets/create_project_dialog.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectBloc, ProjectState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 180,
                  floating: false,
                  pinned: true,
                  backgroundColor: Colors.black,
                  surfaceTintColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  flexibleSpace: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      final top = constraints.biggest.height;
                      const expandedHeight = 180.0;
                      final shrinkOffset = expandedHeight - top;
                      final progress = shrinkOffset / expandedHeight;

                      return Container(
                        color: Colors.black,
                        child: FlexibleSpaceBar(
                          centerTitle: true,
                          titlePadding: const EdgeInsets.only(bottom: 16),
                          background: Container(color: Colors.black),
                          title: SvgPicture.asset(
                            'assets/logo.svg',
                            height: progress < 0.5 ? 60 : 48,
                            fit: BoxFit.contain,
                          ),
                          collapseMode: CollapseMode.parallax,
                        ),
                      );
                    },
                  ),
                ),
              ];
            },
            body: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                border: Border(
                  top: BorderSide(
                    color: Colors.grey[900]!,
                    width: 1,
                  ),
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Projeler',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[100],
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (state is ProjectLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (state is ProjectError)
                      Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                        ),
                      )
                    else if (state is ProjectsLoaded)
                      Expanded(
                        child: state.projects.isEmpty
                            ? const Center(
                                child: Text(
                                  'Henüz proje yok.\nYeni bir proje oluşturun.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            : MediaQuery.removePadding(
                                context: context,
                                removeTop: true,
                                child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  padding: const EdgeInsets.only(bottom: 80),
                                  itemCount: state.projects.length,
                                  itemBuilder: (context, index) {
                                    final project = state.projects[index];
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 12),
                                      child: ProjectCard(project: project),
                                    );
                                  },
                                ),
                              ),
                      )
                    else
                      const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const CreateProjectDialog(),
              );
            },
            label: const Text('Yeni Proje'),
            icon: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
