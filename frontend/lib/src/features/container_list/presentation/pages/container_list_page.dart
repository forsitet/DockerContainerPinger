import 'package:exapmle_docker_pinger/src/core/presentation/bloc/theme/theme_bloc.dart';
import 'package:exapmle_docker_pinger/src/core/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/container_list_bloc.dart';
import '../bloc/container_list_event.dart';
import '../bloc/container_list_state.dart';
import '../../domain/entities/container_entity.dart';

class ContainerListPage extends StatelessWidget {
  const ContainerListPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ContainerListBloc>().add(LoadContainersEvent());
    });
    final themeBloc = BlocProvider.of<ThemeBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Docker Containers'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              context.read<ContainerListBloc>().add(LoadContainersEvent());
            },
          ),
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return Switch(
                activeColor: AppColors.primaryColor,
                value: state.themeMode == ThemeMode.dark,
                onChanged: (value) {
                  themeBloc.add(ToggleThemeEvent());
                },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<ContainerListBloc, ContainerListState>(
        builder: (context, state) {
          if (state is ContainerListLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ContainerListLoaded) {
            return AdaptiveContainerList(containers: state.containers);
          } else if (state is ContainerListError) {
            return Center(child: Text('Ошибка: ${state.message}'));
          }
          return Center(child: Text('Загрузка...'));
        },
      ),
    );
  }
}

class AdaptiveContainerList extends StatefulWidget {
  final List<ContainerEntity> containers;

  const AdaptiveContainerList({super.key, required this.containers});

  @override
  State<AdaptiveContainerList> createState() => _AdaptiveContainerListState();
}

class _AdaptiveContainerListState extends State<AdaptiveContainerList> {
  int _currentPage = 0;
  static const int _itemsPerPage = 8;
  String _sortBy = 'pingTime';
  bool _isAscending = true;

  @override
  Widget build(BuildContext context) {
    List<ContainerEntity> sortedContainers = _sortContainers(widget.containers);
    final pages = _splitIntoPages(sortedContainers, _itemsPerPage);

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 20,
                      columns: [
                        _buildDataColumn('ID', 'id', 200),
                        _buildDataColumn('IP', 'ip', 200),
                        _buildDataColumn('Ping Time (ms)', 'pingTime', 200),
                        _buildDataColumn(
                            'Last Successful Ping', 'lastSuccessfulPing', 200),
                      ],
                      rows: pages[_currentPage].map((container) {
                        return DataRow(cells: [
                          DataCell(Text(container.id)),
                          DataCell(Text(container.ip)),
                          DataCell(Text('${container.pingTime}')),
                          DataCell(
                              Text(container.lastSuccessfulPing.toString())),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
              PageNavigationWidget(
                currentPage: _currentPage,
                totalPages: pages.length,
                onNext: () {
                  setState(() {
                    _currentPage++;
                  });
                },
                onPrevious: () {
                  setState(() {
                    _currentPage--;
                  });
                },
              )
            ],
          );
        } else {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: pages[_currentPage].length,
                  itemBuilder: (context, index) {
                    final container = pages[_currentPage][index];
                    return ListTile(
                      title: Text(container.ip),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ping: ${container.pingTime}ms'),
                          Text('Last Ping: ${container.lastSuccessfulPing}'),
                        ],
                      ),
                    );
                  },
                ),
              ),
              PageNavigationWidget(
                currentPage: _currentPage,
                totalPages: pages.length,
                onNext: () {
                  setState(() {
                    _currentPage++;
                  });
                },
                onPrevious: () {
                  setState(() {
                    _currentPage--;
                  });
                },
              )
            ],
          );
        }
      },
    );
  }

  List<List<ContainerEntity>> _splitIntoPages(
      List<ContainerEntity> containers, int itemsPerPage) {
    final pages = <List<ContainerEntity>>[];
    for (var i = 0; i < containers.length; i += itemsPerPage) {
      pages.add(containers.sublist(
        i,
        i + itemsPerPage > containers.length
            ? containers.length
            : i + itemsPerPage,
      ));
    }
    return pages;
  }

  DataColumn _buildDataColumn(String label, String sortByKey, double width) {
    return DataColumn(
      label: SizedBox(
        width: width,
        child: GestureDetector(
          onTap: () {
            setState(() {
              if (_sortBy == sortByKey) {
                _isAscending = !_isAscending;
              } else {
                _sortBy = sortByKey;
                _isAscending = true;
              }
            });
          },
          child: Row(
            children: [
              Text(label),
              SizedBox(width: 4),
              if (_sortBy == sortByKey)
                Icon(
                  _isAscending ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  size: 16,
                )
              else
                Icon(
                  Icons.sort,
                  size: 16,
                  color: Colors.grey,
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<ContainerEntity> _sortContainers(List<ContainerEntity> containers) {
    return containers.toList()
      ..sort((a, b) {
        int result = 0;
        switch (_sortBy) {
          case 'id':
            result = a.id.compareTo(b.id);
            break;
          case 'ip':
            result = a.ip.compareTo(b.ip);
            break;
          case 'pingTime':
            result = a.pingTime.compareTo(b.pingTime);
            break;
          case 'lastSuccessfulPing':
            result = a.lastSuccessfulPing.compareTo(b.lastSuccessfulPing);
            break;
        }
        return _isAscending ? result : -result;
      });
  }
}

class PageNavigationWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function() onPrevious;
  final Function() onNext;

  const PageNavigationWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: currentPage > 0 ? onPrevious : null,
            color: currentPage > 0
                ? AppColors.getAccentColor(context)
                : AppColors.getBorderColor(context),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Text(
              '${currentPage + 1} / $totalPages',
              style: TextStyle(
                color: AppColors.getTextColor(context),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: currentPage < totalPages - 1 ? onNext : null,
            color: currentPage < totalPages - 1
                ? AppColors.getAccentColor(context)
                : AppColors.getBorderColor(context),
          ),
        ],
      ),
    );
  }
}
