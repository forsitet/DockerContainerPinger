import 'package:exapmle_docker_pinger/generated/app_localizations.dart';
import 'package:exapmle_docker_pinger/src/core/presentation/bloc/auth/auth_bloc.dart';
import 'package:exapmle_docker_pinger/src/core/presentation/bloc/auth/auth_event.dart';
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
              onPressed: () {
                context.read<AuthBloc>().add(LogoutRequested());
              },
              icon: Icon(Icons.logout)),
          SizedBox(width: 16),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              context.read<ContainerListBloc>().add(LoadContainersEvent());
            },
          ),
          SizedBox(width: 16),
          IconButton(
            icon: Icon(Icons.delete_sweep_rounded),
            color: Colors.redAccent,
            onPressed: () async {
              DateTime selectedDate =
                  DateTime.now().subtract(Duration(days: 30));
              await showDialog(
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return AlertDialog(
                        title: Text(
                            AppLocalizations.of(context).deleting_containers),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(AppLocalizations.of(context)
                                .choose_date_to_delete),
                            SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Дата: ${selectedDate.toLocal().toString().split(' ')[0]}',
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.calendar_today),
                                  onPressed: () async {
                                    final picked = await showDatePicker(
                                      context: context,
                                      initialDate: selectedDate,
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime.now(),
                                    );
                                    if (picked != null) {
                                      setState(() {
                                        selectedDate = picked;
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(AppLocalizations.of(context).cancel),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              try {
                                final bloc = context.read<ContainerListBloc>();
                                await Future.microtask(() {
                                  bloc.add(DeleteOldContainersEvent(
                                    before: selectedDate,
                                    onError: (String errorMessage) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            backgroundColor:
                                                AppColors.errorColor,
                                            content: Text(AppLocalizations.of(
                                                    context)
                                                .deleting_containers_error)),
                                      );
                                    },
                                    onSuccess: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            backgroundColor:
                                                AppColors.successColor,
                                            content: Text(AppLocalizations.of(
                                                    context)
                                                .deleting_containers_success)),
                                      );
                                      context
                                          .read<ContainerListBloc>()
                                          .add(LoadContainersEvent());
                                    },
                                  ));
                                });
                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                }
                              } catch (_) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            AppLocalizations.of(context)
                                                .deleting_containers_error)),
                                  );
                                }
                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                }
                              }
                            },
                            child: Text(AppLocalizations.of(context).delete),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
          SizedBox(width: 40),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: BlocBuilder<ThemeBloc, ThemeState>(
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
          ),
        ],
      ),
      body: BlocBuilder<ContainerListBloc, ContainerListState>(
        builder: (context, state) {
          if (state is ContainerListLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ContainerListLoaded) {
            return (state.containers.isNotEmpty)
                ? AdaptiveContainerList(containers: state.containers)
                : Center(
                    child: Text(AppLocalizations.of(context).empty_containers));
          } else if (state is ContainerListError) {
            return Center(
                child: Text(
                    '${AppLocalizations.of(context).get_containers_error}: ${state.message}'));
          }
          return Center(child: Text(AppLocalizations.of(context).loading));
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
                        _buildDataColumn('Name', 'name', 200),
                        _buildDataColumn('IP', 'ip', 200),
                        _buildDataColumn('Ping Time (ms)', 'pingTime', 200),
                        _buildDataColumn(
                            'Last Successful Ping', 'lastSuccessfulPing', 200),
                        _buildDataColumn('Actions', 'actions', 100),
                      ],
                      rows: pages[_currentPage].map((container) {
                        return DataRow(cells: [
                          DataCell(Text(container.id.toString())),
                          DataCell(Text(container.containerName.toString())),
                          DataCell(Text(container.ipAddress)),
                          DataCell(Text('${container.pingTime}')),
                          DataCell(Text(container.lastSuccess.toString())),
                          DataCell(
                            ElevatedButton(
                              onPressed: () {
                                _showPingDialog(context, container);
                              },
                              child: Text(AppLocalizations.of(context).edit),
                            ),
                          ),
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
                      title: Text(container.ipAddress),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ping: ${container.pingTime}ms'),
                          Text('Last Ping: ${container.lastSuccess}'),
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

  void _showPingDialog(BuildContext context, ContainerEntity container) {
    final TextEditingController pingTimeController =
        TextEditingController(text: container.pingTime.toString());
    final TextEditingController nameController =
        TextEditingController(text: container.containerName.toString());
    final TextEditingController ipController =
        TextEditingController(text: container.ipAddress.toString());
    final TextEditingController lastSuccessController =
        TextEditingController(text: container.lastSuccess.toIso8601String());

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context).edit_container),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: 'Имя контейнера'),
                    ),
                    TextField(
                      controller: ipController,
                      decoration: InputDecoration(labelText: 'IP-адрес'),
                    ),
                    TextField(
                      controller: pingTimeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Ping time (ms)'),
                    ),
                    TextField(
                      controller: lastSuccessController,
                      decoration: InputDecoration(
                          labelText: 'Дата последнего успеха (ISO 8601)'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Отмена'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      final updatedPing =
                          double.tryParse(pingTimeController.text);
                      final parsedDate =
                          DateTime.tryParse(lastSuccessController.text);
                      final ip = ipController.text.trim();
                      final name = nameController.text.trim();

                      if (updatedPing == null ||
                          parsedDate == null ||
                          name.isEmpty ||
                          ip.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  AppLocalizations.of(context).invalid_data)),
                        );
                        return;
                      }

                      final updated = container.copyWith(
                        containerName: name,
                        ipAddress: ip,
                        pingTime: updatedPing,
                        lastSuccess: parsedDate,
                      );

                      final bloc = context.read<ContainerListBloc>();

                      await Future.microtask(() {
                        bloc.add(SendPingEvent(
                          updated,
                          onError: (String errorMessage) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(errorMessage)),
                            );
                            Navigator.of(context).pop();
                          },
                          onSuccess: () {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(AppLocalizations.of(context)
                                      .success_save)),
                            );
                            context
                                .read<ContainerListBloc>()
                                .add(LoadContainersEvent());
                          },
                        ));
                      });
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Произошла ошибка: $e'),
                            backgroundColor: AppColors.errorColor,
                          ),
                        );
                      }
                      if (context.mounted) Navigator.of(context).pop();
                    }
                  },
                  child: Text(AppLocalizations.of(context).save),
                ),
              ],
            );
          },
        );
      },
    );
  }

  DataColumn _buildDataColumn(String label, String sortByKey, double width) {
    final isSortable = sortByKey != 'actions';
    return DataColumn(
      label: SizedBox(
        width: width,
        child: GestureDetector(
          onTap: isSortable
              ? () {
                  setState(() {
                    if (_sortBy == sortByKey) {
                      _isAscending = !_isAscending;
                    } else {
                      _sortBy = sortByKey;
                      _isAscending = true;
                    }
                  });
                }
              : null,
          child: isSortable
              ? Row(
                  children: [
                    Text(label),
                    SizedBox(width: 4),
                    if (_sortBy == sortByKey)
                      Icon(
                        _isAscending
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        size: 16,
                      )
                    else
                      Icon(
                        Icons.sort,
                        size: 16,
                        color: Colors.grey,
                      ),
                  ],
                )
              : Center(child: Text(label)),
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
            result = a.id ?? 0.compareTo(b.id ?? 0);
            break;
          case 'name':
            result = a.containerName.compareTo(b.containerName);
            break;
          case 'ip':
            result = a.ipAddress.compareTo(b.ipAddress);
            break;
          case 'pingTime':
            result = a.pingTime.compareTo(b.pingTime);
            break;
          case 'lastSuccessfulPing':
            result = a.lastSuccess.compareTo(b.lastSuccess);
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
