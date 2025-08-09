%clear; close all
rng('default')

n = 2;
% inputs from triplets are: DA_b, SPN_0, LH0
row = triplets(1,:);
DA_b = row.da;
SPN_0 = row.strio;
LH0 = row.lh;

n_tstep = 100;
n_ctx = 10;
n_SPN = 2;
t = linspace(0,2*pi,n_tstep);

% taken from the algorithmics model
DA_a = 0.5;
GPi0 = 1;
RMTg0 = 0.5;
GPi_dim_combination_rules = .2*ones(1,n_SPN);

% create a cortex signal -- make it very rank 1
ctx_ews = [1 .5 repelem(.1,n_ctx-2)];
Sigma = sprandsym(n_ctx,1,ctx_ews); % randomly create a covariance matrix
[ev,~] = eigs(Sigma);
ctx = (sin(t).*ev(:,1) + cos(t).*ev(:,2) + sin(2*t).*ev(:,3))' + ...
    .2*mvnrnd(zeros(1,n_ctx),Sigma,n_tstep);
ctx = ctx .* [repelem(.2,n_tstep/4),repelem(1,n_tstep/2),...
    repelem(.2,n_tstep/4)]';

% after FSI scaling
FSI_a = 1;
FSI_b = 0.1;
FSI = ctx ./ (FSI_b + FSI_a*vecnorm(ctx,2,2));

% SPN
SPN = SPN_0*FSI*ev;
SPN = SPN(:,1:n_SPN);

GPi = -sum(GPi0*GPi_dim_combination_rules.*SPN);

% LH changes the # dimensions used
LH = (GPi+LH0);

% RMTg changes the # dimensions used
RMTg = LH+RMTg0;

% DA signals space
DA = 1./(1 + exp(DA_a.*SPN + RMTg - DA_b));

figure
tiledlayout(3,1)
%{
nexttile
plot(linspace(0,1,n_tstep),ctx,'k','HandleVisibility','off')
ylabel("cortex neuron activity (arb. u.)")
nexttile
plot(linspace(0,1,n_tstep),FSI,'k','HandleVisibility','off')
ylabel("activity after FSI scaling (arb. u.)")
%}
nexttile
plot(linspace(0,1,n_tstep),ctx)
xlabel("time (arb. u.)")
ylabel("CTX activity (arb. u.)")
nexttile
plot(linspace(0,1,n_tstep),DA)
xlabel("time (arb. u.)")
ylabel("DA activity (arb. u.)")
nexttile
plot(linspace(0,1,n_tstep),SPN)
xlabel("time (arb. u.)")
ylabel("SPN activity (arb. u.)")
legend(["dimension 1 (e.g. reward)","dimension 2 (e.g. cost)",...
    "dimension 3 (e.g. hunger)"])

