from operon.sklearn import SymbolicRegressor
import operon._operon as op
from .params._operonregressor import params

est = SymbolicRegressor(
            local_iterations=5,
            generations=100000, # just large enough since we have an evaluation budget
            n_threads=1,
            random_state=None,
            time_limit=10*60*60 # 2 hours
            )

est.set_params(**params)
est.allowed_symbols = 'add,mul,aq,exp,log,sin,tanh,constant,variable'

# double the evals
est.max_evaluations = 1000000


def complexity(est):
    return est._stats['model_complexity'] # scaling nodes not counted

def model(est, X):
    return est.get_model_string(3)