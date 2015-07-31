from ansible.callbacks import AggregateStats

class CustomAggregateStats(AggregateStats):
    """
    Holds stats about per-host activity during playbook runs.
    """
    def __init__(self):
        super(CustomAggregateStats, self).__init__()
        self.results = {}

    def compute(self, runner_results, setup=False, poll=False,
                ignore_errors=False):
        """
        Walk through all results and increment stats.
        """
        super(CustomAggregateStats, self).compute(runner_results, setup, poll,
                                                  ignore_errors)

        for (host, value) in runner_results.get('contacted', {}).iteritems():
            if not host in self.results:
                self.results[host] = []
            if 'invocation' in value and value['invocation']['module_name'] == 'debug' and 'var' in value:
                    self.results[host].append(value['var'])

    def summarize(self, host):
        """
        Return information about a particular host
        """
        summarized_info = super(CustomAggregateStats, self).summarize(host)

        # Adding the info I need
        if host in self.results:
            summarized_info['result'] = self.results[host]

        return summarized_info
