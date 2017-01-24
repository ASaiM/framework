#!/usr/bin/env python

import os
from bioblend import galaxy


admin_email = os.environ.get('GALAXY_DEFAULT_ADMIN_USER', 'admin@galaxy.org')
admin_pass = os.environ.get('GALAXY_DEFAULT_ADMIN_PASSWORD', 'admin')
url = "http://localhost:8080"
gi = galaxy.GalaxyInstance(url=url, email=admin_email, password=admin_pass)

wf = galaxy.workflows.WorkflowClient(gi)

wf.import_workflow_from_local_path('/home/galaxy/asaim_main_workflow.ga')
wf.import_workflow_from_local_path('/home/galaxy/asaim_taxonomic_result_comparative_analysis.ga')
wf.import_workflow_from_local_path('/home/galaxy/asaim_functional_result_comparative_analysis.ga')
wf.import_workflow_from_local_path('/home/galaxy/asaim_go_slim_terms_comparative_analysis.ga')
wf.import_workflow_from_local_path('/home/galaxy/asaim_taxonomically_related_functional_result_comparative_analysis.ga')