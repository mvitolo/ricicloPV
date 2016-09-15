package mapelli.info.paviadifferenziata.model;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by francesco on 14/06/16.
 */
public class Waste {

    private List<DisposeOption> disposeOptions;

    public List<DisposeOption> getDisposeOptions() {
        return disposeOptions;
    }

    public enum DisposeOption {
        GENERIC,
        LANDFILL,
        AUTHORIZED_DEALERS,
        PAPER,
        PLASTIC,
        HUMID,
        GLASS,
        LARGE,
        GREEN,
        CLOTHES;
    }


    private String name;

    public Waste (String name, List<DisposeOption> disposeOptions){

        this.name = name;
        this.disposeOptions = disposeOptions;
    }

    public Waste (String name, DisposeOption disposeOption) {
        this(name, new ArrayList<DisposeOption>());

        List<DisposeOption> l= new ArrayList<>(1);
        l.add(disposeOption);
        this.disposeOptions = l;
    }

    public String getName() {
        return name;
    }

    @Override
    public String toString() {
        return getName();
    }
}
