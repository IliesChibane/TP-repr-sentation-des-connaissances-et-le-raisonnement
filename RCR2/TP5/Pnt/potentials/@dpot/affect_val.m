function   [Bel_joint] =  affect_val(Bel_joint,instance, alpha_consistency);

Bel_joint.T(instance)=alpha_consistency;
