function KF(time,gap)
    rng("shuffle");
    step=time/gap; 
    int64(step); % discretize the time step
    d=zeros(1,step);
    for i=1:step
        d(i)=i;
    end
    F=[1 gap 0 0;0 1 0 0;0 0 1 gap;0 0 0 1]; % state transition matrix
    G=[0.5*gap^2;gap;0.5*gap^2;gap]; % accerelation matrix
    var_a=0.5; % need improve, randomly set here
    Q=G*G.'*var_a; % the covariance of the process noise
    H=[1 0 0 0;0 0 1 0]; % observation matrix
    var_z=1; % observation error
    R=[var_z 0;0 var_z]; % the covariance of the observation noise
    % construct the KF %
    loc.priori=cell(1,step); % predicted state estimate
    loc.posterior=cell(1,step);
    loc.vx_truth=zeros(1,step);
    loc.x_truth=zeros(1,step);
    loc.vy_truth=zeros(1,step);
    loc.y_truth=zeros(1,step);
    loc.vx_pred=zeros(1,step);
    loc.x_pred=zeros(1,step);
    loc.vy_pred=zeros(1,step);
    loc.y_pred=zeros(1,step);
    loc.x_obs=zeros(1,step);
    loc.y_obs=zeros(1,step);
    P.priori=cell(1,step);
    P.posterior=cell(1,step);
    Y=cell(1,step);
    S=cell(1,step);
    K=cell(1,step);
    truth=cell(1,step);
    z=cell(1,step);
    % setup the initial state %
    truth{1,1}=[0;0;0;0];
    loc.vx_truth(1)=0;
    loc.x_truth(1)=0;
    loc.vy_truth(1)=0;
    loc.y_truth(1)=0;
    loc.x_obs(1)=0;
    loc.y_obs(1)=0;
    loc.vx_pred(1)=0;
    loc.x_pred(1)=0;
    loc.vy_pred(1)=0;
    loc.y_pred(1)=0;
    % True track %
    for i=2:step
        truth{1,i}=F*truth{1,i-1}+G*sqrt(var_a)*randn(1);
        loc.vx_truth(i)=truth{1,i}(2,1);
        loc.x_truth(i)=truth{1,i}(1,1);
        loc.vy_truth(i)=truth{1,i}(4,1);
        loc.y_truth(i)=truth{1,i}(3,1);
    end
    % Observation %
    for i=1:step
        z{1,i}=H*truth{1,i}+[1;1]*sqrt(var_z)*randn(1);
        loc.x_obs(i)=z{1,i}(1,1);
        loc.y_obs(i)=z{1,i}(2,1);
    end
    loc.posterior{1,1}=truth{1,1}; % initial state
    P.posterior{1,1}=zeros(4); % know exactly the initial state
    % Kalman filtering %
    for i=2:step
        loc.priori{1,i}=F*loc.posterior{1,i-1};
        P.priori{1,i}=F*P.posterior{1,i-1}*F.'+Q;
        Y{1,i}=z{1,i}-H*loc.priori{1,i};
        S{1,i}=H*P.priori{1,i}*H.'+R;
        K{1,i}=P.priori{1,i}*H.'/S{1,i};
        loc.posterior{1,i}=loc.priori{1,i}+K{1,i}*Y{1,i};
        P.posterior{1,i}=(eye(4)-K{1,i}*H)*P.priori{1,i};
        loc.x_pred(i)=loc.posterior{1,i}(1,1);
        loc.vx_pred(i)=loc.posterior{1,i}(2,1);
        loc.y_pred(i)=loc.posterior{1,i}(3,1);
        loc.vy_pred(i)=loc.posterior{1,i}(4,1);
    end
    s(1)=subplot(2,2,1);
    plot(d,loc.x_truth);
    hold on;
    plot(d,loc.x_obs);
    hold on;
    plot(d,loc.x_pred);
    hold off;
    t(1)=title(s(1),'location info in x axis');
    xlabel({'Steps',[num2str(step),' ',num2str(gap),'s-step']});
    ylabel('Position (m)');
    legend("Actual Pos","Observation","Predicted Pos");
    legend('boxoff');
    s(2)=subplot(2,2,2);
    plot(d,loc.y_truth);
    hold on;
    plot(d,loc.y_obs);
    hold on;
    plot(d,loc.y_pred);
    hold off;
    title(s(2),'location info in y axis');
    xlabel({'Steps',[num2str(step),' ',num2str(gap),'s-step']});
    ylabel('Position (m)');
    legend("Actual Pos","Observation","Predicted Pos");
    legend('boxoff');
    s(3)=subplot(2,2,3);
    plot(d,loc.vx_truth);
    hold on;
    plot(d,loc.vx_pred);
    hold off;
    title(s(3),'velocity info in x axis');
    xlabel({'Steps',[num2str(step),' ',num2str(gap),'s-step']});
    ylabel('Velocity (m\s)');
    legend("Actual Velocity","Predicted Velocity",'Location','southeast');
    legend('boxoff');
    s(4)=subplot(2,2,4);
    plot(d,loc.vy_truth);
    hold on;
    plot(d,loc.vy_pred);
    hold off;
    title(s(4),'velocity info in y axis');
    xlabel({'Steps',[num2str(step),' ',num2str(gap),'s-step']});
    ylabel('Velocity (m\s)');
    legend("Actual Velocity","Predicted Velocity",'Location','southeast');
    legend('boxoff');
end