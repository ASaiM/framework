#!/usr/bin/env python
# -*- coding: utf-8 -*-

from bioblend import galaxy
from bioblend import toolshed


if __name__ == '__main__':
    gi_url = "http://172.21.23.6:8080/"
    ts_url = "http://172.21.23.6:9009/"
    name = "qiime"
    owner = "iuc"
    tool_panel_section_id = "qiime_rRNA_taxonomic_assignation"

    gi = galaxy.GalaxyInstance(url=gi_url, key='8a099e97b0a83c73ead9f5b0fe19f4be')

    ts = toolshed.ToolShedInstance(url=ts_url)

    changeset_revision = str(ts.repositories.get_ordered_installable_revisions(name,
        owner)[-1])

    gi.toolShed.install_repository_revision(ts_url, name, owner, changeset_revision,
        install_tool_dependencies=True, install_repository_dependencies=False, 
        tool_panel_section_id=tool_panel_section_id)

