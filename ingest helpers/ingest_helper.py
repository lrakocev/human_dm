# ingest_helper.py
def get_prefs(pref_str, trial_date):
    import time
    import ast

    if trial_date[0] == '0':
        trial_date = ["Mon May 22 00:00:00.00 1998 UTC"]

    trial_tup = time.strptime(trial_date[0], "%a %b %d %H:%M:%S.%f %Y %Z")
    trial_date = time.mktime(trial_tup)
        
    ## date of the switch = june 8, 2023
    time_tup = (2023,6,8,0,0,0,3,159,-1)
    switch_date = time.mktime(time_tup)

    prefs = ast.literal_eval(pref_str[0])

    return prefs, trial_date < switch_date

def choose_prefs_new(pref_dict):
    import itertools
    import copy

    pref_dict = {int(k):int(v) for k,v in pref_dict.items()}
    vals = sorted(list(pref_dict.values()))
    
    max_diff = 0
    index_combos = [i for i in itertools.combinations(range(0,6), 2)]
    
    best_diff_list = [] 
    for c in index_combos:
        ind1, ind2 = c
        copy_vals = copy.deepcopy(vals)
        del copy_vals[ind1]
        del copy_vals[ind2-1]
        
        new_diffs = [abs(e[1] - e[0]) for e in itertools.permutations(copy_vals, 2)]
        new_diff = sum(new_diffs)/len(new_diffs)
        
        if new_diff > max_diff: 
            max_diff = new_diff
            best_diff_list = copy_vals
        
    prefs = {k:v for (k,v) in pref_dict.items() if v in best_diff_list}
    
    return prefs

def choose_prefs_old(pref_dict, trial_levels):

    trial_levels = [str(int(k)) for k in trial_levels]
    
    prefs = {int(k):int(v) for k,v in pref_dict.items() if k in trial_levels}

    return prefs

def choose_prefs(pref_dict, trial_levels, use_old_prefs):

    if use_old_prefs:
        return choose_prefs_old(pref_dict, trial_levels)
    return choose_prefs_new(pref_dict)

def map_prefs(pref_dict, trial_levels, use_old_prefs):

    chosen_pref_dict = choose_prefs(pref_dict, trial_levels, use_old_prefs)
    chosen_prefs = sorted(chosen_pref_dict, key=chosen_pref_dict.get)
    chosen_prefs_str = [str(x) for x in chosen_prefs]
    
    choice_range = list(range(1,5))
    pref_map = dict(zip(chosen_prefs_str, choice_range))
    
    return pref_map

def convert(pref_str, trial_levels, trial_date):
    # have to pass in these things individually since you can't pass in a table from matlab

    pref_dict, use_old_prefs = get_prefs(pref_str, trial_date)
    pref_map = map_prefs(pref_dict, trial_levels, use_old_prefs)

    return pref_map