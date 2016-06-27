package mapelli.info.paviadifferenziata.model;

/**
 * Created by francesco on 14/06/16.
 */
public class Waste {

    private Type type;

    public Type getType() {
        return type;
    }

    public enum Type {
        GENERIC
    }


    private String name;

    public Waste (String name, Type type){

        this.name = name;
        this.type = type;
    }

    public String getName() {
        return name;
    }

    @Override
    public String toString() {
        return getName();
    }
}
